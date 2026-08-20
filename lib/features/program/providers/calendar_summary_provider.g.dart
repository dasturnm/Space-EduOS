// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.

@ProviderFor(calendarSummary)
final calendarSummaryProvider = CalendarSummaryFamily._();

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.

final class CalendarSummaryProvider extends $FunctionalProvider<
        AsyncValue<AcademicSummaryModel>,
        AcademicSummaryModel,
        FutureOr<AcademicSummaryModel>>
    with
        $FutureModifier<AcademicSummaryModel>,
        $FutureProvider<AcademicSummaryModel> {
  /// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
  /// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
  CalendarSummaryProvider._(
      {required CalendarSummaryFamily super.from,
      required (
        String, {
        String? tahunAjaranId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'calendarSummaryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$calendarSummaryHash();

  @override
  String toString() {
    return r'calendarSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AcademicSummaryModel> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AcademicSummaryModel> create(Ref ref) {
    final argument = this.argument as (
      String, {
      String? tahunAjaranId,
    });
    return calendarSummary(
      ref,
      argument.$1,
      tahunAjaranId: argument.tahunAjaranId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarSummaryHash() => r'8316714e019ae5f533234e105e27babbfdd801c5';

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.

final class CalendarSummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<AcademicSummaryModel>,
            (
              String, {
              String? tahunAjaranId,
            })> {
  CalendarSummaryFamily._()
      : super(
          retry: null,
          name: r'calendarSummaryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
  /// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.

  CalendarSummaryProvider call(
    String programId, {
    String? tahunAjaranId,
  }) =>
      CalendarSummaryProvider._(argument: (
        programId,
        tahunAjaranId: tahunAjaranId,
      ), from: this);

  @override
  String toString() => r'calendarSummaryProvider';
}
