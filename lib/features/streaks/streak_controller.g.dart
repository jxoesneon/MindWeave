// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StreakController)
final streakControllerProvider = StreakControllerProvider._();

final class StreakControllerProvider
    extends $AsyncNotifierProvider<StreakController, int> {
  StreakControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakControllerHash();

  @$internal
  @override
  StreakController create() => StreakController();
}

String _$streakControllerHash() => r'42bc03d3c1364ddb3267ef07b18b384ecb4415c5';

abstract class _$StreakController extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
