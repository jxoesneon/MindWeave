import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:mindweave/core/audio/audio_service.dart';
import '../mocks.dart';

void main() {
  late AudioService audioService;
  late MockSoLoud mockSoLoud;
  late MockAudioSession mockAudioSession;

  setUp(() {
    registerTestFallbacks();

    mockSoLoud = MockSoLoud();
    mockAudioSession = MockAudioSession();

    // Default behaviors
    when(() => mockSoLoud.init()).thenAnswer((_) async {});
    when(() => mockSoLoud.isInitialized).thenReturn(true);
    when(
      () => mockSoLoud.loadWaveform(any(), any(), any(), any()),
      // ignore: invalid_use_of_internal_member
    ).thenAnswer((_) async => AudioSource(const SoundHash(1)));
    when(() => mockSoLoud.setWaveformFreq(any(), any())).thenAnswer((_) {});
    when(
      () => mockSoLoud.play(any(), looping: any(named: 'looping')),
    ).thenAnswer((_) async => const SoundHandle(1));
    when(() => mockSoLoud.setPan(any(), any())).thenAnswer((_) {});
    when(() => mockSoLoud.setVolume(any(), any())).thenAnswer((_) {});
    when(() => mockSoLoud.stop(any())).thenAnswer((_) async {});
    when(() => mockSoLoud.disposeSource(any())).thenAnswer((_) async {});
    when(() => mockSoLoud.deinit()).thenAnswer((_) async {});
    when(
      () => mockSoLoud.setRelativePlaySpeed(any(), any()),
    ).thenAnswer((_) {});

    when(() => mockAudioSession.configure(any())).thenAnswer((_) async {});
    when(() => mockAudioSession.setActive(any())).thenAnswer((_) async => true);

    audioService = AudioService(
      soloud: mockSoLoud,
      audioSession: mockAudioSession,
    );
  });

  tearDown(() {
    reset(mockSoLoud);
    reset(mockAudioSession);
  });

  group('AudioService', () {
    test('init() initializes SoLoud and configures AudioSession', () async {
      await audioService.init();

      verify(() => mockSoLoud.init()).called(1);
      verify(() => mockAudioSession.configure(any())).called(1);
    });

    test(
      'startBinaural() plays left and right waves with correct panning',
      () async {
        await audioService.init();
        await audioService.startBinaural(
          leftFreq: 200.0,
          rightFreq: 210.0,
          volume: 0.5,
        );

        // Verify waveform loading
        verify(
          () => mockSoLoud.loadWaveform(WaveForm.sin, false, 1.0, 0.0),
        ).called(2);

        // Verify frequency setting
        verify(() => mockSoLoud.setWaveformFreq(any(), 200.0)).called(1);
        verify(() => mockSoLoud.setWaveformFreq(any(), 210.0)).called(1);

        // Verify session activation
        verify(() => mockAudioSession.setActive(true)).called(1);

        // Verify playing with looping
        verify(() => mockSoLoud.play(any(), looping: true)).called(2);

        // Verify panning (left: -1.0, right: 1.0)
        verify(() => mockSoLoud.setPan(any(), -1.0)).called(1);
        verify(() => mockSoLoud.setPan(any(), 1.0)).called(1);

        // Verify volume setting
        verify(() => mockSoLoud.setVolume(any(), 0.5)).called(2);
      },
    );

    test('updateFrequencies() updates relative play speed', () async {
      await audioService.init();
      await audioService.startBinaural(
        leftFreq: 200.0,
        rightFreq: 210.0,
        volume: 0.5,
      );

      audioService.updateFrequencies(205.0, 215.0);

      // Verify relative play speed is set correctly (205/200 = 1.025, 215/210 = 1.0238)
      verify(() => mockSoLoud.setRelativePlaySpeed(any(), any())).called(2);
    });

    test('startBackgroundNoise() loads and plays memory audio', () async {
      await audioService.init();
      final wavData = Uint8List.fromList([0, 1, 2, 3]);

      when(
        () => mockSoLoud.loadMem(any(), any()),
        // ignore: invalid_use_of_internal_member
      ).thenAnswer((_) async => AudioSource(const SoundHash(2)));

      await audioService.startBackgroundNoise(wavData, volume: 0.2);

      verify(
        () => mockSoLoud.loadMem('background_noise.wav', wavData),
      ).called(1);
      verify(
        () => mockSoLoud.play(any(), volume: 0.2, looping: true),
      ).called(1);
    });

    test('setBackgroundVolume() sets volume on noise handle', () async {
      await audioService.init();
      final wavData = Uint8List.fromList([0, 1, 2, 3]);

      when(
        () => mockSoLoud.loadMem(any(), any()),
        // ignore: invalid_use_of_internal_member
      ).thenAnswer((_) async => AudioSource(const SoundHash(2)));

      await audioService.startBackgroundNoise(wavData, volume: 0.2);
      audioService.setBackgroundVolume(0.5);

      verify(() => mockSoLoud.setVolume(any(), 0.5)).called(1);
    });

    test('stop() stops and disposes all resources', () async {
      await audioService.init();
      await audioService.startBinaural(
        leftFreq: 200.0,
        rightFreq: 210.0,
        volume: 0.5,
      );

      await audioService.stop();

      verify(() => mockSoLoud.stop(any())).called(2); // Left and right
      verify(() => mockSoLoud.disposeSource(any())).called(2);
      verify(() => mockAudioSession.setActive(false)).called(1);
    });

    test('setVolume() sets volume on binaural handles', () async {
      await audioService.init();
      await audioService.startBinaural(
        leftFreq: 200.0,
        rightFreq: 210.0,
        volume: 0.5,
      );

      audioService.setVolume(0.8);

      verify(() => mockSoLoud.setVolume(any(), 0.8)).called(2);
    });

    test('dispose() calls deinit on SoLoud', () async {
      await audioService.init();
      audioService.dispose();

      verify(() => mockSoLoud.deinit()).called(1);
    });
  });
}
