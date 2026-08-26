// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sertifikasi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sertifikasiService)
final sertifikasiServiceProvider = SertifikasiServiceProvider._();

final class SertifikasiServiceProvider extends $FunctionalProvider<
    SertifikasiService,
    SertifikasiService,
    SertifikasiService> with $Provider<SertifikasiService> {
  SertifikasiServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sertifikasiServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sertifikasiServiceHash();

  @$internal
  @override
  $ProviderElement<SertifikasiService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SertifikasiService create(Ref ref) {
    return sertifikasiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SertifikasiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SertifikasiService>(value),
    );
  }
}

String _$sertifikasiServiceHash() =>
    r'02033829bcf01801e60a608e4d90da7ef789e0d0';

@ProviderFor(CertificateNotifier)
final certificateProvider = CertificateNotifierFamily._();

final class CertificateNotifierProvider extends $AsyncNotifierProvider<
    CertificateNotifier, List<SertifikasiModel>> {
  CertificateNotifierProvider._(
      {required CertificateNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'certificateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$certificateNotifierHash();

  @override
  String toString() {
    return r'certificateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CertificateNotifier create() => CertificateNotifier();

  @override
  bool operator ==(Object other) {
    return other is CertificateNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$certificateNotifierHash() =>
    r'12f94eec42980526839750d1a146796529d57774';

final class CertificateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            CertificateNotifier,
            AsyncValue<List<SertifikasiModel>>,
            List<SertifikasiModel>,
            FutureOr<List<SertifikasiModel>>,
            String> {
  CertificateNotifierFamily._()
      : super(
          retry: null,
          name: r'certificateProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CertificateNotifierProvider call(
    String organizationId,
  ) =>
      CertificateNotifierProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'certificateProvider';
}

abstract class _$CertificateNotifier
    extends $AsyncNotifier<List<SertifikasiModel>> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<List<SertifikasiModel>> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<SertifikasiModel>>, List<SertifikasiModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<SertifikasiModel>>, List<SertifikasiModel>>,
        AsyncValue<List<SertifikasiModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
