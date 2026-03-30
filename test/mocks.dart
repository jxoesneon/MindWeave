import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/models/user_session.dart';
import 'package:mindweave/core/audio/audio_state.dart';
import 'package:mindweave/core/audio/mixer_state.dart';
import 'package:mindweave/core/audio/audio_service.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import 'package:mindweave/core/audio/mixer_controller.dart';
import 'package:mindweave/features/health/health_controller.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/features/favorites/favorites_controller.dart';

class MockSoLoud extends Mock implements SoLoud {
  @override
  void setInaudibleBehavior(SoundHandle handle, bool mustPause, bool kill) {}
}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockPostgrestClient extends Mock implements PostgrestClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}

/// A fake that implements GoTrueClient to avoid issues with mocking getters in mocktail.
class FakeGoTrueClient extends Fake implements GoTrueClient {
  User? _currentUser;
  @override
  User? get currentUser => _currentUser;
  set currentUser(User? value) => _currentUser = value;

  @override
  Stream<AuthState> get onAuthStateChange => const Stream.empty();
}

/// A custom mock that manually overrides the auth getter to ensure compatibility.
class CustomMockSupabaseClient extends Mock implements SupabaseClient {
  final GoTrueClient _auth;
  CustomMockSupabaseClient(this._auth);

  @override
  GoTrueClient get auth => _auth;
}

class MockUser extends Mock implements User {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'u1';
}

class MockAudioService extends Mock implements AudioService {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockSessionRepository extends Mock implements SessionRepositoryImpl {}

class MockMixerController extends Mock implements MixerController {}

class MockHealthController extends Mock implements HealthController {}

class MockStreakController extends Mock implements StreakController {}

class MockFavoritesController extends Mock implements FavoritesController {}

// In Supabase 2.10.x, builders have 3 generics or 1 depending on where they come from.
// Using SupabaseQueryBuilder as seen in the test error logs.
class MockPostgrestQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class MockPostgrestTransformBuilder extends Mock
    implements PostgrestTransformBuilder<Map<String, dynamic>> {}

class MockPostgrestMaybeTransformBuilder extends Mock
    implements PostgrestTransformBuilder<Map<String, dynamic>?> {}

class MockPostgrestListTransformBuilder extends Mock
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {}

// A fake that implements both the builder interface and Future, so it can be returned and awaited.
class FakePostgrestBuilder<T> extends Fake
    implements
        PostgrestFilterBuilder<T>,
        PostgrestTransformBuilder<T>,
        Future<T> {
  final T value;
  FakePostgrestBuilder(this.value);

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) {
    return Future.value(value).then(onValue, onError: onError);
  }
}

class MockBox<T> extends Mock implements Box<T> {}

class FakeHive extends Fake implements HiveInterface {
  final Map<String, Box> _boxes = {};
  void setBox(String name, Box box) => _boxes[name] = box;

  @override
  Future<Box<T>> openBox<T>(String name,
      {HiveCipher? encryptionCipher,
      bool crashRecovery = true,
      String? path,
      Uint8List? bytes,
      String? collection,
      List<int>? encryptionKey,
      dynamic keyComparator,
      dynamic compactionStrategy}) async {
    return _boxes[name] as Box<T>;
  }
}

class MockStorageService extends Mock implements StorageService {}

// Registration of fallback values for mocktail arguments
bool _fallbacksRegistered = false;
void registerTestFallbacks() {
  if (_fallbacksRegistered) return;
  _fallbacksRegistered = true;

  registerFallbackValue(const Duration(seconds: 0));
  registerFallbackValue(
    const AudioState(
      isPlaying: false,
      carrierFrequency: 0,
      beatFrequency: 0,
      volume: 0,
    ),
  );
  registerFallbackValue(
    const MixerState(backgroundVolume: 0, noiseType: NoiseType.none),
  );
  registerFallbackValue(
    UserPreset(
      id: '',
      userId: '',
      name: '',
      carrierFrequency: 0,
      beatFrequency: 0,
      createdAt: DateTime.now(),
    ),
  );
  registerFallbackValue(
    UserSession(
      id: '',
      userId: '',
      presetId: '',
      durationSeconds: 0,
      startedAt: DateTime.now(),
    ),
  );
  registerFallbackValue(Uint8List(0));
  registerFallbackValue(<dynamic>[]);
  registerFallbackValue(<Map<String, dynamic>>[]);
  
  // flutter_soloud types for any() matchers
  registerFallbackValue(const SoundHandle(1));
  // ignore: invalid_use_of_internal_member, prefer_const_constructors
  registerFallbackValue(AudioSource(const SoundHash(1)));
}
