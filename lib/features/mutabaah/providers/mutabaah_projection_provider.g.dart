// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutabaah_projection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider untuk mengambil proyeksi akademik (Sisa pertemuan & estimasi kelulusan)
/// Menggunakan parameter [siswaId] dan [modul]

@ProviderFor(mutabaahProjection)
final mutabaahProjectionProvider = MutabaahProjectionFamily._();

/// Provider untuk mengambil proyeksi akademik (Sisa pertemuan & estimasi kelulusan)
/// Menggunakan parameter [siswaId] dan [modul]

final class MutabaahProjectionProvider extends $FunctionalProvider<
        AsyncValue<MutabaahProjectionModel>,
        MutabaahProjectionModel,
        FutureOr<MutabaahProjectionModel>>
    with
        $FutureModifier<MutabaahProjectionModel>,
        $FutureProvider<MutabaahProjectionModel> {
  /// Provider untuk mengambil proyeksi akademik (Sisa pertemuan & estimasi kelulusan)
  /// Menggunakan parameter [siswaId] dan [modul]
  MutabaahProjectionProvider._(
      {required MutabaahProjectionFamily super.from,
      required (
        String,
        ModulModel,
      )
          super.argument})
      : super(
          retry: null,
          name: r'mutabaahProjectionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mutabaahProjectionHash();

  @override
  String toString() {
    return r'mutabaahProjectionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MutabaahProjectionModel> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MutabaahProjectionModel> create(Ref ref) {
    final argument = this.argument as (
      String,
      ModulModel,
    );
    return mutabaahProjection(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MutabaahProjectionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mutabaahProjectionHash() =>
    r'11dc76ed8aa302c96ebef7025f1d6ff73f936b75';

/// Provider untuk mengambil proyeksi akademik (Sisa pertemuan & estimasi kelulusan)
/// Menggunakan parameter [siswaId] dan [modul]

final class MutabaahProjectionFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<MutabaahProjectionModel>,
            (
              String,
              ModulModel,
            )> {
  MutabaahProjectionFamily._()
      : super(
          retry: null,
          name: r'mutabaahProjectionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider untuk mengambil proyeksi akademik (Sisa pertemuan & estimasi kelulusan)
  /// Menggunakan parameter [siswaId] dan [modul]

  MutabaahProjectionProvider call(
    String siswaId,
    ModulModel modul,
  ) =>
      MutabaahProjectionProvider._(argument: (
        siswaId,
        modul,
      ), from: this);

  @override
  String toString() => r'mutabaahProjectionProvider';
}
