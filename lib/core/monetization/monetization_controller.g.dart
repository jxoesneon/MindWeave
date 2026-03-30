// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MonetizationController)
final monetizationControllerProvider = MonetizationControllerProvider._();

final class MonetizationControllerProvider
    extends $NotifierProvider<MonetizationController, bool> {
  MonetizationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monetizationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monetizationControllerHash();

  @$internal
  @override
  MonetizationController create() => MonetizationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$monetizationControllerHash() =>
    r'230b73e30c3c74f6a8cce930958df87cd9ab7835';

abstract class _$MonetizationController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
