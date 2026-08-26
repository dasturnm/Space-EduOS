// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(attendanceService)
final attendanceServiceProvider = AttendanceServiceProvider._();

final class AttendanceServiceProvider extends $FunctionalProvider<
    AttendanceService,
    AttendanceService,
    AttendanceService> with $Provider<AttendanceService> {
  AttendanceServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'attendanceServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$attendanceServiceHash();

  @$internal
  @override
  $ProviderElement<AttendanceService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AttendanceService create(Ref ref) {
    return attendanceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceService>(value),
    );
  }
}

String _$attendanceServiceHash() => r'a65bf2e589251b99b7461d9e865b6657e414f083';

@ProviderFor(AttendanceSessionNotifier)
final attendanceSessionProvider = AttendanceSessionNotifierFamily._();

final class AttendanceSessionNotifierProvider extends $AsyncNotifierProvider<
    AttendanceSessionNotifier, List<AttendanceSessionModel>> {
  AttendanceSessionNotifierProvider._(
      {required AttendanceSessionNotifierFamily super.from,
      required (
        String,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'attendanceSessionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$attendanceSessionNotifierHash();

  @override
  String toString() {
    return r'attendanceSessionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AttendanceSessionNotifier create() => AttendanceSessionNotifier();

  @override
  bool operator ==(Object other) {
    return other is AttendanceSessionNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attendanceSessionNotifierHash() =>
    r'd9b494325708f8991ebac128050ca59ff332f316';

final class AttendanceSessionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            AttendanceSessionNotifier,
            AsyncValue<List<AttendanceSessionModel>>,
            List<AttendanceSessionModel>,
            FutureOr<List<AttendanceSessionModel>>,
            (
              String,
              String,
            )> {
  AttendanceSessionNotifierFamily._()
      : super(
          retry: null,
          name: r'attendanceSessionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AttendanceSessionNotifierProvider call(
    String organizationId,
    String classId,
  ) =>
      AttendanceSessionNotifierProvider._(argument: (
        organizationId,
        classId,
      ), from: this);

  @override
  String toString() => r'attendanceSessionProvider';
}

abstract class _$AttendanceSessionNotifier
    extends $AsyncNotifier<List<AttendanceSessionModel>> {
  late final _$args = ref.$arg as (
    String,
    String,
  );
  String get organizationId => _$args.$1;
  String get classId => _$args.$2;

  FutureOr<List<AttendanceSessionModel>> build(
    String organizationId,
    String classId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<AttendanceSessionModel>>,
        List<AttendanceSessionModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<AttendanceSessionModel>>,
            List<AttendanceSessionModel>>,
        AsyncValue<List<AttendanceSessionModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}
