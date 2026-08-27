// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnalyticsDashboardNotifier)
final analyticsDashboardProvider = AnalyticsDashboardNotifierFamily._();

final class AnalyticsDashboardNotifierProvider
    extends $AsyncNotifierProvider<AnalyticsDashboardNotifier, AnalyticsState> {
  AnalyticsDashboardNotifierProvider._(
      {required AnalyticsDashboardNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'analyticsDashboardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$analyticsDashboardNotifierHash();

  @override
  String toString() {
    return r'analyticsDashboardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnalyticsDashboardNotifier create() => AnalyticsDashboardNotifier();

  @override
  bool operator ==(Object other) {
    return other is AnalyticsDashboardNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsDashboardNotifierHash() =>
    r'8f7d8bdfe981ceb6693974fdf891bb6ef1813053';

final class AnalyticsDashboardNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            AnalyticsDashboardNotifier,
            AsyncValue<AnalyticsState>,
            AnalyticsState,
            FutureOr<AnalyticsState>,
            String> {
  AnalyticsDashboardNotifierFamily._()
      : super(
          retry: null,
          name: r'analyticsDashboardProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AnalyticsDashboardNotifierProvider call(
    String organizationId,
  ) =>
      AnalyticsDashboardNotifierProvider._(
          argument: organizationId, from: this);

  @override
  String toString() => r'analyticsDashboardProvider';
}

abstract class _$AnalyticsDashboardNotifier
    extends $AsyncNotifier<AnalyticsState> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<AnalyticsState> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AnalyticsState>, AnalyticsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AnalyticsState>, AnalyticsState>,
        AsyncValue<AnalyticsState>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
