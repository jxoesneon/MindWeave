import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../audio/audio_controller.dart';
import '../models/user_session.dart';
import '../monetization/monetization_controller.dart';
import '../repository/session_repository.dart';
import '../../features/streaks/streak_controller.dart';
import '../supabase/supabase_client_provider.dart';

part 'user_session_controller.g.dart';

@riverpod
class UserSessionController extends _$UserSessionController {
  late final _supabase = ref.read(supabaseClientProvider);
  DateTime? _sessionStartTime;
  String? _currentPresetId;

  @override
  UserSession? build() {
    // Listen to audio controller state to start/stop session
    ref.listen(audioControllerProvider, (previous, next) {
      if (next.isPlaying && !(previous?.isPlaying ?? false)) {
        _startSession(next.selectedPreset?.id);
      } else if (!next.isPlaying && (previous?.isPlaying ?? false)) {
        _stopSession();
      }
    });

    return null;
  }

  void _startSession(String? presetId) {
    _sessionStartTime = DateTime.now();
    _currentPresetId = presetId;
  }

  Future<void> _stopSession() async {
    if (_sessionStartTime == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(_sessionStartTime!).inSeconds;

    // Minimum 10 seconds to record a session
    if (duration < 10) {
      _sessionStartTime = null;
      return;
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final session = UserSession(
      id: const Uuid().v4(),
      userId: userId,
      presetId: _currentPresetId ?? 'custom',
      durationSeconds: duration,
      startedAt: _sessionStartTime!,
      endedAt: endTime,
    );

    try {
      // Use repository for local/remote sync
      await ref.read(sessionRepositoryProvider).saveSession(session);
      
      // Update monetization stats
      ref.read(monetizationControllerProvider.notifier).recordSession(duration);
      
      // Refresh streak
      ref.read(streakControllerProvider.notifier).refreshStreak();
    } catch (e) {
      debugPrint('Error recording session: $e');
    }

    _sessionStartTime = null;
  }
}
