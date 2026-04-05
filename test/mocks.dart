import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/models/user_session.dart';
import 'package:mindweave/core/services/analytics_service.dart';
import 'package:mindweave/core/services/session_history_service.dart';
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

class MockAudioSession extends Mock implements AudioSession {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

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
  @override
  String get email => 'test@example.com';
  @override
  Map<String, dynamic> get appMetadata => {};
  @override
  Map<String, dynamic> get userMetadata => {};
  @override
  String get aud => 'authenticated';
  @override
  String get createdAt => DateTime.now().toIso8601String();
}

class MockAudioService extends Mock implements AudioService {}

class FakeAudioService extends Fake implements AudioService {
  AudioState _state = const AudioState(
    isPlaying: false,
    carrierFrequency: 440,
    beatFrequency: 10,
    volume: 0.5,
  );

  AudioState get state => _state;

  @override
  Future<void> init() async {}

  @override
  Future<void> startBinaural({
    required double leftFreq,
    required double rightFreq,
    double volume = 0.5,
  }) async {
    _state = _state.copyWith(
      isPlaying: true,
      carrierFrequency: (leftFreq + rightFreq) / 2,
      beatFrequency: (rightFreq - leftFreq).abs(),
      volume: volume,
    );
  }

  @override
  Future<void> stop() async {
    _state = _state.copyWith(isPlaying: false);
  }

  @override
  void setVolume(double volume) {
    _state = _state.copyWith(volume: volume);
  }

  @override
  void updateFrequencies(double leftFreq, double rightFreq) {
    _state = _state.copyWith(
      carrierFrequency: (leftFreq + rightFreq) / 2,
      beatFrequency: (rightFreq - leftFreq).abs(),
    );
  }

  @override
  void dispose() {}
}

class FakeFirebaseApp extends Fake implements FirebaseApp {
  @override
  String get name => '[DEFAULT]';
}

class FakeFirebaseRemoteConfig extends Fake implements FirebaseRemoteConfig {
  final Map<String, RemoteConfigValue> _values = {};

  @override
  Future<bool> activate() async => true;

  @override
  Future<void> fetch() async {}

  @override
  Future<bool> fetchAndActivate() async => true;

  @override
  RemoteConfigValue getValue(String key) {
    return _values[key] ??
        RemoteConfigValue(Uint8List(0), ValueSource.valueDefault);
  }

  @override
  Map<String, RemoteConfigValue> getAll() => _values;

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {}

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {}
}

class FakePosthog extends Fake implements Posthog {
  final List<Map<String, dynamic>> capturedEvents = [];

  @override
  Future<void> debug(bool enabled) async {}

  @override
  Future<void> capture({
    required String eventName,
    Map<String, Object>? properties,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async {
    capturedEvents.add({
      'name': eventName,
      'props': properties,
      'user_props': userProperties,
      'user_props_once': userPropertiesSetOnce,
    });
  }

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async {}

  @override
  Future<void> screen({
    required String screenName,
    Map<String, Object>? properties,
  }) async {}

  @override
  Future<void> reset() async {}

  @override
  Future<void> enable() async {}

  @override
  Future<void> disable() async {}
}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockSessionRepository extends Mock implements SessionRepositoryImpl {}

class MockMixerController extends Mock implements MixerController {}

class MockHealthController extends Mock implements HealthController {}

class MockStreakController extends Mock implements StreakController {}

class MockFavoritesController extends Mock implements FavoritesController {}

class MockSessionHistoryService extends Mock implements SessionHistoryService {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

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
  bool isBoxOpen(String name) => _boxes.containsKey(name);

  @override
  Box<T> box<T>(String name) => _boxes[name] as Box<T>;

  @override
  Future<Box<T>> openBox<T>(
    String name, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    String? collection,
    List<int>? encryptionKey,
    dynamic keyComparator,
    dynamic compactionStrategy,
  }) async {
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

  // BrainwavePreset for any() matchers
  registerFallbackValue(
    const BrainwavePreset(
      id: 'test',
      name: 'Test',
      band: BrainwaveBand.alpha,
      beatFrequency: 10,
      defaultCarrierFrequency: 200,
      description: 'Test preset',
      iconPath: 'assets/icons/test.png',
      accentColorValue: 0xFF000000,
    ),
  );
}

/// Setup common mock behaviors for SessionHistoryService
void setupMockSessionHistoryService(MockSessionHistoryService mock) {
  registerTestFallbacks();

  when(() => mock.initialize()).thenAnswer((_) async {});

  when(
    () => mock.startSession(
      preset: any(named: 'preset'),
      beatFrequency: any(named: 'beatFrequency'),
      carrierFrequency: any(named: 'carrierFrequency'),
      volume: any(named: 'volume'),
      targetDuration: any(named: 'targetDuration'),
    ),
  ).thenAnswer((_) async => 'test-session-id');

  when(
    () => mock.completeSession(
      sessionId: any(named: 'sessionId'),
      actualDuration: any(named: 'actualDuration'),
    ),
  ).thenAnswer((_) async {});
}

/// Setup common mock behaviors for AnalyticsService
void setupMockAnalyticsService(MockAnalyticsService mock) {
  registerTestFallbacks();

  when(() => mock.initialize()).thenAnswer((_) async {});

  when(
    () => mock.trackSessionStart(
      presetId: any(named: 'presetId'),
      band: any(named: 'band'),
      beatFrequency: any(named: 'beatFrequency'),
      carrierFrequency: any(named: 'carrierFrequency'),
    ),
  ).thenAnswer((_) async {});

  when(
    () => mock.trackSessionStop(
      presetId: any(named: 'presetId'),
      durationSeconds: any(named: 'durationSeconds'),
      completed: any(named: 'completed'),
    ),
  ).thenAnswer((_) async {});
}

/// Setup common mock behaviors for FavoritesRepository
void setupMockFavoritesRepository(MockFavoritesRepository mock) {
  registerTestFallbacks();

  when(() => mock.getFavorites()).thenAnswer((_) async => []);

  when(() => mock.addFavorite(any())).thenAnswer((invocation) async {
    final preset = invocation.positionalArguments[0] as UserPreset;
    return preset.copyWith(
      id: 'test-id-${DateTime.now().millisecondsSinceEpoch}',
    );
  });

  when(() => mock.deleteFavorite(any())).thenAnswer((_) async {});
}

/// Setup common mock behaviors for SessionRepository
void setupMockSessionRepository(MockSessionRepository mock) {
  registerTestFallbacks();

  when(() => mock.saveSession(any())).thenAnswer((_) async {});

  when(() => mock.getSessions()).thenAnswer((_) async => []);

  when(() => mock.calculateCurrentStreak()).thenAnswer((_) async => 0);
}
