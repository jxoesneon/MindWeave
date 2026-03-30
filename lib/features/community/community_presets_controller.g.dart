// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_presets_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommunityPresetsController)
final communityPresetsControllerProvider =
    CommunityPresetsControllerProvider._();

final class CommunityPresetsControllerProvider
    extends
        $AsyncNotifierProvider<CommunityPresetsController, List<UserPreset>> {
  CommunityPresetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityPresetsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityPresetsControllerHash();

  @$internal
  @override
  CommunityPresetsController create() => CommunityPresetsController();
}

String _$communityPresetsControllerHash() =>
    r'1c0582ee1474c5aba1ecd0a5f229fbdb315298de';

abstract class _$CommunityPresetsController
    extends $AsyncNotifier<List<UserPreset>> {
  FutureOr<List<UserPreset>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<UserPreset>>, List<UserPreset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserPreset>>, List<UserPreset>>,
              AsyncValue<List<UserPreset>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
