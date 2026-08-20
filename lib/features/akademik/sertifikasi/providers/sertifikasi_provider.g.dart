// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sertifikasi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SertifikasiNotifier)
final sertifikasiProvider = SertifikasiNotifierProvider._();

final class SertifikasiNotifierProvider
    extends $NotifierProvider<SertifikasiNotifier, AsyncValue<void>> {
  SertifikasiNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sertifikasiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sertifikasiNotifierHash();

  @$internal
  @override
  SertifikasiNotifier create() => SertifikasiNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$sertifikasiNotifierHash() =>
    r'ee8a9e7e1f4fa593cf6d08c83861ed558d85c704';

abstract class _$SertifikasiNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
