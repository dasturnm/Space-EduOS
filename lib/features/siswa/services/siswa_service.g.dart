// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'siswa_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(siswaService)
final siswaServiceProvider = SiswaServiceProvider._();

final class SiswaServiceProvider
    extends $FunctionalProvider<SiswaService, SiswaService, SiswaService>
    with $Provider<SiswaService> {
  SiswaServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'siswaServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$siswaServiceHash();

  @$internal
  @override
  $ProviderElement<SiswaService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SiswaService create(Ref ref) {
    return siswaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiswaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiswaService>(value),
    );
  }
}

String _$siswaServiceHash() => r'41621d7c895ba7dc9595861b0cf20da61f3b162c';
