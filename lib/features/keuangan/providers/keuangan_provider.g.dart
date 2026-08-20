// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keuangan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salarySettings)
final salarySettingsProvider = SalarySettingsProvider._();

final class SalarySettingsProvider extends $FunctionalProvider<
        AsyncValue<SalarySettingsModel?>,
        SalarySettingsModel?,
        FutureOr<SalarySettingsModel?>>
    with
        $FutureModifier<SalarySettingsModel?>,
        $FutureProvider<SalarySettingsModel?> {
  SalarySettingsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'salarySettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$salarySettingsHash();

  @$internal
  @override
  $FutureProviderElement<SalarySettingsModel?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SalarySettingsModel?> create(Ref ref) {
    return salarySettings(ref);
  }
}

String _$salarySettingsHash() => r'6d58339ba79ff10e4cc26343ed81d63bbbf011f4';

@ProviderFor(monthlyPayroll)
final monthlyPayrollProvider = MonthlyPayrollFamily._();

final class MonthlyPayrollProvider extends $FunctionalProvider<
        AsyncValue<Map<String, dynamic>>,
        Map<String, dynamic>,
        FutureOr<Map<String, dynamic>>>
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  MonthlyPayrollProvider._(
      {required MonthlyPayrollFamily super.from,
      required ({
        String guruId,
        DateTime month,
      })
          super.argument})
      : super(
          retry: null,
          name: r'monthlyPayrollProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monthlyPayrollHash();

  @override
  String toString() {
    return r'monthlyPayrollProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as ({
      String guruId,
      DateTime month,
    });
    return monthlyPayroll(
      ref,
      guruId: argument.guruId,
      month: argument.month,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyPayrollProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyPayrollHash() => r'38fc8eccf3039680912548058fdaefc2c7e5b395';

final class MonthlyPayrollFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<Map<String, dynamic>>,
            ({
              String guruId,
              DateTime month,
            })> {
  MonthlyPayrollFamily._()
      : super(
          retry: null,
          name: r'monthlyPayrollProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MonthlyPayrollProvider call({
    required String guruId,
    required DateTime month,
  }) =>
      MonthlyPayrollProvider._(argument: (
        guruId: guruId,
        month: month,
      ), from: this);

  @override
  String toString() => r'monthlyPayrollProvider';
}

@ProviderFor(KeuanganNotifier)
final keuanganProvider = KeuanganNotifierProvider._();

final class KeuanganNotifierProvider
    extends $NotifierProvider<KeuanganNotifier, AsyncValue<void>> {
  KeuanganNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'keuanganProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keuanganNotifierHash();

  @$internal
  @override
  KeuanganNotifier create() => KeuanganNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$keuanganNotifierHash() => r'4cc4ff3e69d79e1084fd018f2d167b268981e8d4';

abstract class _$KeuanganNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
