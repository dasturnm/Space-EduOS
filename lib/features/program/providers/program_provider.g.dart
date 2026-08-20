// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProgramNotifier)
final programProvider = ProgramNotifierProvider._();

final class ProgramNotifierProvider
    extends $AsyncNotifierProvider<ProgramNotifier, List<ProgramModel>> {
  ProgramNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'programProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$programNotifierHash();

  @$internal
  @override
  ProgramNotifier create() => ProgramNotifier();
}

String _$programNotifierHash() => r'98c42e9bf765b69d4fa3a45a07ff2c4a0581a0e0';

abstract class _$ProgramNotifier extends $AsyncNotifier<List<ProgramModel>> {
  FutureOr<List<ProgramModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ProgramModel>>, List<ProgramModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ProgramModel>>, List<ProgramModel>>,
        AsyncValue<List<ProgramModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// --- UTILITAS ESTIMASI (Poin 3 Blueprint) ---
/// Mengambil daftar hari efektif program secara reaktif untuk kalkulasi estimasi tanggal selesai.

@ProviderFor(programHariEfektif)
final programHariEfektifProvider = ProgramHariEfektifFamily._();

/// --- UTILITAS ESTIMASI (Poin 3 Blueprint) ---
/// Mengambil daftar hari efektif program secara reaktif untuk kalkulasi estimasi tanggal selesai.

final class ProgramHariEfektifProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// --- UTILITAS ESTIMASI (Poin 3 Blueprint) ---
  /// Mengambil daftar hari efektif program secara reaktif untuk kalkulasi estimasi tanggal selesai.
  ProgramHariEfektifProvider._(
      {required ProgramHariEfektifFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'programHariEfektifProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$programHariEfektifHash();

  @override
  String toString() {
    return r'programHariEfektifProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as String;
    return programHariEfektif(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramHariEfektifProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$programHariEfektifHash() =>
    r'107d9e2b9b75c0e4ff3ed22c490f8f9f94ed4da4';

/// --- UTILITAS ESTIMASI (Poin 3 Blueprint) ---
/// Mengambil daftar hari efektif program secara reaktif untuk kalkulasi estimasi tanggal selesai.

final class ProgramHariEfektifFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, String> {
  ProgramHariEfektifFamily._()
      : super(
          retry: null,
          name: r'programHariEfektifProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// --- UTILITAS ESTIMASI (Poin 3 Blueprint) ---
  /// Mengambil daftar hari efektif program secara reaktif untuk kalkulasi estimasi tanggal selesai.

  ProgramHariEfektifProvider call(
    String programId,
  ) =>
      ProgramHariEfektifProvider._(argument: programId, from: this);

  @override
  String toString() => r'programHariEfektifProvider';
}
