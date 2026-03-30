import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:fake_async/fake_async.dart';
import '../../mocks.dart';

void main() {
  late MockAudioService mockAudioService;
  late ProviderContainer container;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockAudioService = MockAudioService();
    
    when(() => mockAudioService.init()).thenAnswer((_) async => {});
    when(() => mockAudioService.startBinaural(
      leftFreq: any(named: 'leftFreq'),
      rightFreq: any(named: 'rightFreq'),
      volume: any(named: 'volume'),
    )).thenAnswer((_) async => {});
    when(() => mockAudioService.stop()).thenAnswer((_) async => {});
    when(() => mockAudioService.setVolume(any())).thenReturn(null);
    when(() => mockAudioService.updateFrequencies(any(), any())).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        audioServiceProvider.overrideWithValue(mockAudioService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AudioController Tests', () {
    test('initial state is correct and service inits', () {
      final sub = container.listen(audioControllerProvider, (_, _) {});
      final state = container.read(audioControllerProvider);
      
      expect(state.isPlaying, false);
      expect(state.volume, 0.5);
      verify(() => mockAudioService.init()).called(1);
      sub.close();
    });

    test('togglePlay starts audio when currently stopped', () async {
      final sub = container.listen(audioControllerProvider, (_, _) {});
      final notifier = container.read(audioControllerProvider.notifier);
      
      await notifier.togglePlay();
      
      final state = container.read(audioControllerProvider);
      expect(state.isPlaying, true);
      sub.close();
    });

    test('timer countdown correctly updates remainingTime', () {
      fakeAsync((async) {
        // Keep the autoDispose provider alive during the fakeAsync zone
        final sub = container.listen(audioControllerProvider, (prev, next) {});
        final notifier = container.read(audioControllerProvider.notifier);
        
        async.elapse(const Duration(milliseconds: 100));
        
        notifier.setTimer(const Duration(seconds: 40));
        notifier.togglePlay(); 
        
        async.elapse(const Duration(milliseconds: 100));
        
        var state = container.read(audioControllerProvider);
        expect(state.isPlaying, true);
        
        async.elapse(const Duration(seconds: 5));
        
        state = container.read(audioControllerProvider);
        expect(state.remainingTime?.inSeconds, 35);
        
        sub.close();
      });
    });

    test('updateCarrierFreq triggers service update if playing', () async {
      final sub = container.listen(audioControllerProvider, (_, _) {});
      final notifier = container.read(audioControllerProvider.notifier);
      
      await notifier.togglePlay();
      notifier.updateCarrierFreq(440.0);
      
      verify(() => mockAudioService.updateFrequencies(any(), any())).called(1);
      sub.close();
    });
  });
}
