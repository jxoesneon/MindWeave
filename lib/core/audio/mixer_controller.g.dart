// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MixerController)
final mixerControllerProvider = MixerControllerProvider._();

final class MixerControllerProvider
    extends $NotifierProvider<MixerController, MixerState> {
  MixerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixerControllerHash();

  @$internal
  @override
  MixerController create() => MixerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MixerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MixerState>(value),
    );
  }
}

String _$mixerControllerHash() => r'acf337a052afd9cf7f96bfae3ef93f8a9a9d21c9';

abstract class _$MixerController extends $Notifier<MixerState> {
  MixerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MixerState, MixerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MixerState, MixerState>,
              MixerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
