// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSessionController)
final userSessionControllerProvider = UserSessionControllerProvider._();

final class UserSessionControllerProvider
    extends $NotifierProvider<UserSessionController, UserSession?> {
  UserSessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSessionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSessionControllerHash();

  @$internal
  @override
  UserSessionController create() => UserSessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSession?>(value),
    );
  }
}

String _$userSessionControllerHash() =>
    r'15037414011926b7f793c95eeff22e6addd82ee9';

abstract class _$UserSessionController extends $Notifier<UserSession?> {
  UserSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserSession?, UserSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserSession?, UserSession?>,
              UserSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
