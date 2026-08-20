// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kelas_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(kelasService)
final kelasServiceProvider = KelasServiceProvider._();

final class KelasServiceProvider
    extends $FunctionalProvider<KelasService, KelasService, KelasService>
    with $Provider<KelasService> {
  KelasServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kelasServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kelasServiceHash();

  @$internal
  @override
  $ProviderElement<KelasService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KelasService create(Ref ref) {
    return kelasService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KelasService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KelasService>(value),
    );
  }
}

String _$kelasServiceHash() => r'f477323bff8703f0ae800cd0200b196b3cf7e870';
