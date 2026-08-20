// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guru_dan_staff_bulk_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(guruDanStaffBulkService)
final guruDanStaffBulkServiceProvider = GuruDanStaffBulkServiceProvider._();

final class GuruDanStaffBulkServiceProvider extends $FunctionalProvider<
    GuruDanStaffBulkService,
    GuruDanStaffBulkService,
    GuruDanStaffBulkService> with $Provider<GuruDanStaffBulkService> {
  GuruDanStaffBulkServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'guruDanStaffBulkServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$guruDanStaffBulkServiceHash();

  @$internal
  @override
  $ProviderElement<GuruDanStaffBulkService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuruDanStaffBulkService create(Ref ref) {
    return guruDanStaffBulkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuruDanStaffBulkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuruDanStaffBulkService>(value),
    );
  }
}

String _$guruDanStaffBulkServiceHash() =>
    r'a6968b9f7e40eb8215df5d176111fbd6f1638642';
