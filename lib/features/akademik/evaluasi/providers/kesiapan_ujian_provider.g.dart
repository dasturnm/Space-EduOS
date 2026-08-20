// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kesiapan_ujian_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider reaktif untuk mengambil daftar santri yang statusnya siap mengikuti ujian formal.

@ProviderFor(kesiapanUjianList)
final kesiapanUjianListProvider = KesiapanUjianListProvider._();

/// Provider reaktif untuk mengambil daftar santri yang statusnya siap mengikuti ujian formal.

final class KesiapanUjianListProvider extends $FunctionalProvider<
        AsyncValue<List<SiswaModel>>,
        List<SiswaModel>,
        FutureOr<List<SiswaModel>>>
    with $FutureModifier<List<SiswaModel>>, $FutureProvider<List<SiswaModel>> {
  /// Provider reaktif untuk mengambil daftar santri yang statusnya siap mengikuti ujian formal.
  KesiapanUjianListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kesiapanUjianListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kesiapanUjianListHash();

  @$internal
  @override
  $FutureProviderElement<List<SiswaModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SiswaModel>> create(Ref ref) {
    return kesiapanUjianList(ref);
  }
}

String _$kesiapanUjianListHash() => r'88f345058790b3a5c9cf93197aaeacd57844f661';
