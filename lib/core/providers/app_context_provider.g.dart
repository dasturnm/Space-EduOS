// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_context_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppContext)
final appContextProvider = AppContextProvider._();

final class AppContextProvider
    extends $NotifierProvider<AppContext, AppContextState> {
  AppContextProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appContextProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appContextHash();

  @$internal
  @override
  AppContext create() => AppContext();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppContextState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppContextState>(value),
    );
  }
}

String _$appContextHash() => r'051b1b05f0e6730e4c5a6032ed2c3664c7ddbab9';

abstract class _$AppContext extends $Notifier<AppContextState> {
  AppContextState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppContextState, AppContextState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AppContextState, AppContextState>,
        AppContextState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
