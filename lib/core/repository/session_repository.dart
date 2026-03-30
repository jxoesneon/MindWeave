import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/storage_service.dart';
import '../supabase/supabase_client_provider.dart';

part 'session_repository.g.dart';

@riverpod
SessionRepositoryImpl sessionRepository(Ref ref) => SessionRepositoryImpl(
  storageService: ref.watch(storageServiceProvider),
  supabase: ref.watch(supabaseClientProvider),
);

class SessionRepositoryImpl {
  final SupabaseClient _supabase;
  final StorageService _storageService;
  static const String _boxName = 'sessions_v1';

  SessionRepositoryImpl({
    required SupabaseClient supabase,
    required StorageService storageService,
  }) : _supabase = supabase,
       _storageService = storageService;

  Future<void> saveSession(UserSession session) async {
    // 1. Save to local Hive for offline access and fallback
    final box = await _storageService.openBox<Map>(_boxName);
    await box.put(session.id, session.toJson());

    // 2. Attempt to save to Supabase
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase.from('user_sessions').upsert(session.toJson());
      }
    } catch (e) {
      // Log error but don't fail, as we have local storage
      debugPrint('Supabase session sync failed: $e');
    }
  }

  Future<List<UserSession>> getSessions() async {
    // 1. Try to fetch from Supabase first for latest data
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await _supabase
            .from('user_sessions')
            .select()
            .eq('user_id', userId)
            .order('started_at', ascending: false);

        final list = (response as List)
            .map((json) => UserSession.fromJson(json))
            .toList();

        // Update local cache
        final box = await _storageService.openBox<Map>(_boxName);
        for (var session in list) {
          await box.put(session.id, session.toJson());
        }

        return list;
      }
    } catch (e) {
      debugPrint('Supabase fetch failed, falling back to local: $e');
    }

    // 2. Fallback to Hive
    final box = await _storageService.openBox<Map>(_boxName);
    return box.values
        .map((m) => UserSession.fromJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  Future<int> calculateCurrentStreak() async {
    final sessions = await getSessions();
    if (sessions.isEmpty) return 0;

    final today = DateTime.now();
    final uniqueDays =
        sessions
            .map(
              (s) => DateTime(
                s.startedAt.year,
                s.startedAt.month,
                s.startedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    if (uniqueDays.isEmpty) return 0;

    // Check if the most recent session was today or yesterday
    final latestDate = uniqueDays.first;
    final diff = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(latestDate).inDays;

    if (diff > 1) return 0; // Streak broken

    int streak = 0;
    DateTime currentCheck = latestDate;

    for (var date in uniqueDays) {
      if (date == currentCheck) {
        streak++;
        currentCheck = currentCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
