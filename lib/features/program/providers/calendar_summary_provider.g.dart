// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calendarSummaryHash() => r'a591c166bbaf997c48bc09cee19a0f78dd53ead6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
///
/// Copied from [calendarSummary].
@ProviderFor(calendarSummary)
const calendarSummaryProvider = CalendarSummaryFamily();

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
///
/// Copied from [calendarSummary].
class CalendarSummaryFamily extends Family<AsyncValue<AcademicSummaryModel>> {
  /// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
  /// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
  ///
  /// Copied from [calendarSummary].
  const CalendarSummaryFamily();

  /// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
  /// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
  ///
  /// Copied from [calendarSummary].
  CalendarSummaryProvider call(
    String programId, {
    String? tahunAjaranId,
  }) {
    return CalendarSummaryProvider(
      programId,
      tahunAjaranId: tahunAjaranId,
    );
  }

  @override
  CalendarSummaryProvider getProviderOverride(
    covariant CalendarSummaryProvider provider,
  ) {
    return call(
      provider.programId,
      tahunAjaranId: provider.tahunAjaranId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calendarSummaryProvider';
}

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
///
/// Copied from [calendarSummary].
class CalendarSummaryProvider
    extends AutoDisposeFutureProvider<AcademicSummaryModel> {
  /// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
  /// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
  ///
  /// Copied from [calendarSummary].
  CalendarSummaryProvider(
    String programId, {
    String? tahunAjaranId,
  }) : this._internal(
          (ref) => calendarSummary(
            ref as CalendarSummaryRef,
            programId,
            tahunAjaranId: tahunAjaranId,
          ),
          from: calendarSummaryProvider,
          name: r'calendarSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calendarSummaryHash,
          dependencies: CalendarSummaryFamily._dependencies,
          allTransitiveDependencies:
              CalendarSummaryFamily._allTransitiveDependencies,
          programId: programId,
          tahunAjaranId: tahunAjaranId,
        );

  CalendarSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
    required this.tahunAjaranId,
  }) : super.internal();

  final String programId;
  final String? tahunAjaranId;

  @override
  Override overrideWith(
    FutureOr<AcademicSummaryModel> Function(CalendarSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalendarSummaryProvider._internal(
        (ref) => create(ref as CalendarSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
        tahunAjaranId: tahunAjaranId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AcademicSummaryModel> createElement() {
    return _CalendarSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarSummaryProvider &&
        other.programId == programId &&
        other.tahunAjaranId == tahunAjaranId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);
    hash = _SystemHash.combine(hash, tahunAjaranId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalendarSummaryRef on AutoDisposeFutureProviderRef<AcademicSummaryModel> {
  /// The parameter `programId` of this provider.
  String get programId;

  /// The parameter `tahunAjaranId` of this provider.
  String? get tahunAjaranId;
}

class _CalendarSummaryProviderElement
    extends AutoDisposeFutureProviderElement<AcademicSummaryModel>
    with CalendarSummaryRef {
  _CalendarSummaryProviderElement(super.provider);

  @override
  String get programId => (origin as CalendarSummaryProvider).programId;
  @override
  String? get tahunAjaranId =>
      (origin as CalendarSummaryProvider).tahunAjaranId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
