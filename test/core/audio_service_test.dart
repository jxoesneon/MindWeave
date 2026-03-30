import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:audio_session/audio_session.dart';
import 'package:mindweave/core/audio/audio_service.dart';
import '../mocks.dart';

// SoundHandle and AudioSource are extension types in flutter_soloud 2.0+
// and cannot be mocked by mocktail. Use constants for verification.
final dummySoundHandle = const SoundHandle(1);
// ignore: invalid_use_of_internal_member, prefer_const_constructors
final dummyAudioSource = AudioSource(const SoundHash(1));

class MockAudioSession extends Mock implements AudioSession {}

void main() {
  late MockSoLoud mockSoLoud;
  late MockAudioSession mockAudioSession;
  late AudioService audioService;

  setUpAll(() {
    registerFallbackValue(WaveForm.sin);
    registerFallbackValue(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
    ));
    registerTestFallbacks();
  });

  setUp(() {
    mockSoLoud = MockSoLoud();
    mockAudioSession = MockAudioSession();

    // Setup basic mock behaviors for SoLoud
    when(() => mockSoLoud.init()).thenAnswer((_) async => {});
    when(() => mockSoLoud.deinit()).thenReturn(null);
    when(() => mockSoLoud.loadWaveform(any(), any(), any(), any()))
        .thenAnswer((_) async => dummyAudioSource);
    when(() => mockSoLoud.loadMem(any(), any()))
        .thenAnswer((_) async => dummyAudioSource);
    when(() => mockSoLoud.setWaveformFreq(any(), any())).thenReturn(null);
    // flutter_soloud 2.x play returns Future<SoundHandle>
    when(() => mockSoLoud.play(any(), volume: any(named: 'volume'), looping: any(named: 'looping')))
        .thenAnswer((_) async => dummySoundHandle);
    when(() => mockSoLoud.setPan(any(), any())).thenReturn(null);
    when(() => mockSoLoud.setVolume(any(), any())).thenReturn(null);
    when(() => mockSoLoud.setRelativePlaySpeed(any(), any())).thenReturn(null);
    when(() => mockSoLoud.stop(any())).thenAnswer((_) async => true);
    when(() => mockSoLoud.disposeSource(any())).thenAnswer((_) async => true);
    when(() => mockSoLoud.loadMem(any(), any()))
        .thenAnswer((_) async => dummyAudioSource);

    // Setup basic mock behaviors for AudioSession
    when(() => mockAudioSession.configure(any())).thenAnswer((_) async {});
    when(() => mockAudioSession.setActive(any())).thenAnswer((_) async => true);

    audioService = AudioService(soloud: mockSoLoud, audioSession: mockAudioSession);
  });

  group('AudioService', () {
    test('init() initializes SoLoud and configures AudioSession', () async {
      await audioService.init();

      verify(() => mockSoLoud.init()).called(1);
      verify(() => mockAudioSession.configure(any())).called(1);
    });

    test('startBinaural() plays left and right waves with correct panning and frequency', () async {
      await audioService.startBinaural(leftFreq: 300, rightFreq: 310, volume: 0.5);

      verify(() => mockSoLoud.loadWaveform(WaveForm.sin, false, 1.0, 0.0)).called(2);
      verify(() => mockSoLoud.setWaveformFreq(dummyAudioSource, 300)).called(1);
      verify(() => mockSoLoud.setWaveformFreq(dummyAudioSource, 310)).called(1);
      
      verify(() => mockAudioSession.setActive(true)).called(1);
      verify(() => mockSoLoud.play(dummyAudioSource)).called(2);
      
      verify(() => mockSoLoud.setPan(dummySoundHandle, -1.0)).called(1);
      verify(() => mockSoLoud.setPan(dummySoundHandle, 1.0)).called(1);
      verify(() => mockSoLoud.setVolume(dummySoundHandle, 0.5)).called(2);
    });

    test('updateFrequencies() updates relative play speed', () async {
      // Must start first to get the handles cached
      await audioService.startBinaural(leftFreq: 300, rightFreq: 310);
      
      audioService.updateFrequencies(400, 410);

      verify(() => mockSoLoud.setRelativePlaySpeed(dummySoundHandle, 400 / 440.0)).called(1);
      verify(() => mockSoLoud.setRelativePlaySpeed(dummySoundHandle, 410 / 440.0)).called(1);
    });

    test('startBackgroundNoise() loads and plays memory audio', () async {
      final dummyData = Uint8List(10);
      await audioService.startBackgroundNoise(dummyData, volume: 0.3);

      verify(() => mockSoLoud.loadMem('background_noise.wav', dummyData)).called(1);
      verify(() => mockSoLoud.play(dummyAudioSource, volume: 0.3, looping: true)).called(1);
    });

    test('setBackgroundVolume() sets volume on noise handle', () async {
      final dummyData = Uint8List(10);
      await audioService.startBackgroundNoise(dummyData, volume: 0.3);

      audioService.setBackgroundVolume(0.8);

      verify(() => mockSoLoud.setVolume(dummySoundHandle, 0.8)).called(1);
    });

    test('stop() stops and disposes all resources and deactivates AudioSession', () async {
      // Start something
      await audioService.startBinaural(leftFreq: 300, rightFreq: 310);
      final dummyData = Uint8List(10);
      await audioService.startBackgroundNoise(dummyData);

      await audioService.stop();

      verify(() => mockSoLoud.stop(dummySoundHandle)).called(3);
      verify(() => mockSoLoud.disposeSource(dummyAudioSource)).called(3);
      verify(() => mockAudioSession.setActive(false)).called(2);
    });

    test('setVolume() sets volume on binaural handles', () async {
      await audioService.startBinaural(leftFreq: 300, rightFreq: 310);
      
      audioService.setVolume(0.7);

      verify(() => mockSoLoud.setVolume(dummySoundHandle, 0.7)).called(2);
    });

    test('dispose() calls deinit on SoLoud', () {
      audioService.dispose();
      verify(() => mockSoLoud.deinit()).called(1);
    });
  });
}
