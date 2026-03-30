// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(presets)
final presetsProvider = PresetsProvider._();

final class PresetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BrainwavePreset>>,
          List<BrainwavePreset>,
          FutureOr<List<BrainwavePreset>>
        >
    with
        $FutureModifier<List<BrainwavePreset>>,
        $FutureProvider<List<BrainwavePreset>> {
  PresetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetsHash();

  @$internal
  @override
  $FutureProviderElement<List<BrainwavePreset>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BrainwavePreset>> create(Ref ref) {
    return presets(ref);
  }
}

String _$presetsHash() => r'e27f798647bed9a0d99410632df672ca47512e7c';
