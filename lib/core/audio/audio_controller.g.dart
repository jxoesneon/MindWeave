// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AudioController)
final audioControllerProvider = AudioControllerProvider._();

final class AudioControllerProvider
    extends $NotifierProvider<AudioController, AudioState> {
  AudioControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioControllerHash();

  @$internal
  @override
  AudioController create() => AudioController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioState>(value),
    );
  }
}

String _$audioControllerHash() => r'a5c92cd01cd6a5833193360c1bba60babfb2595e';

abstract class _$AudioController extends $Notifier<AudioState> {
  AudioState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AudioState, AudioState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AudioState, AudioState>,
              AudioState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
