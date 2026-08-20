// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_evaluasi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider ini bertugas mengambil daftar riwayat evaluasi/ujian berdasarkan ID Siswa.
/// Karena menggunakan @riverpod, data akan di-cache dan otomatis diperbarui jika ada perubahan.

@ProviderFor(riwayatEvaluasi)
final riwayatEvaluasiProvider = RiwayatEvaluasiFamily._();

/// Provider ini bertugas mengambil daftar riwayat evaluasi/ujian berdasarkan ID Siswa.
/// Karena menggunakan @riverpod, data akan di-cache dan otomatis diperbarui jika ada perubahan.

final class RiwayatEvaluasiProvider extends $FunctionalProvider<
        AsyncValue<List<EvaluasiRecordModel>>,
        List<EvaluasiRecordModel>,
        FutureOr<List<EvaluasiRecordModel>>>
    with
        $FutureModifier<List<EvaluasiRecordModel>>,
        $FutureProvider<List<EvaluasiRecordModel>> {
  /// Provider ini bertugas mengambil daftar riwayat evaluasi/ujian berdasarkan ID Siswa.
  /// Karena menggunakan @riverpod, data akan di-cache dan otomatis diperbarui jika ada perubahan.
  RiwayatEvaluasiProvider._(
      {required RiwayatEvaluasiFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'riwayatEvaluasiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$riwayatEvaluasiHash();

  @override
  String toString() {
    return r'riwayatEvaluasiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EvaluasiRecordModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EvaluasiRecordModel>> create(Ref ref) {
    final argument = this.argument as String;
    return riwayatEvaluasi(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RiwayatEvaluasiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$riwayatEvaluasiHash() => r'2a76d6a81d2efd95d321950390f0f447128bcce7';

/// Provider ini bertugas mengambil daftar riwayat evaluasi/ujian berdasarkan ID Siswa.
/// Karena menggunakan @riverpod, data akan di-cache dan otomatis diperbarui jika ada perubahan.

final class RiwayatEvaluasiFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<EvaluasiRecordModel>>, String> {
  RiwayatEvaluasiFamily._()
      : super(
          retry: null,
          name: r'riwayatEvaluasiProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider ini bertugas mengambil daftar riwayat evaluasi/ujian berdasarkan ID Siswa.
  /// Karena menggunakan @riverpod, data akan di-cache dan otomatis diperbarui jika ada perubahan.

  RiwayatEvaluasiProvider call(
    String siswaId,
  ) =>
      RiwayatEvaluasiProvider._(argument: siswaId, from: this);

  @override
  String toString() => r'riwayatEvaluasiProvider';
}
