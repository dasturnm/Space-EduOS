// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Filter status pendaftar ('', 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak')

@ProviderFor(AdmissionStatusFilter)
final admissionStatusFilterProvider = AdmissionStatusFilterProvider._();

/// Filter status pendaftar ('', 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak')
final class AdmissionStatusFilterProvider
    extends $NotifierProvider<AdmissionStatusFilter, String> {
  /// Filter status pendaftar ('', 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak')
  AdmissionStatusFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'admissionStatusFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$admissionStatusFilterHash();

  @$internal
  @override
  AdmissionStatusFilter create() => AdmissionStatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$admissionStatusFilterHash() =>
    r'a075f6941effc33c5fba3e91f01a0337d021df81';

/// Filter status pendaftar ('', 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak')

abstract class _$AdmissionStatusFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
