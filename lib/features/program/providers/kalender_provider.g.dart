// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kalender_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarNotifier)
final calendarProvider = CalendarNotifierFamily._();

final class CalendarNotifierProvider
    extends $AsyncNotifierProvider<CalendarNotifier, List<AgendaModel>> {
  CalendarNotifierProvider._(
      {required CalendarNotifierFamily super.from,
      required DateTime super.argument})
      : super(
          retry: null,
          name: r'calendarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$calendarNotifierHash();

  @override
  String toString() {
    return r'calendarProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CalendarNotifier create() => CalendarNotifier();

  @override
  bool operator ==(Object other) {
    return other is CalendarNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarNotifierHash() => r'f28d5203f63c3f921d88f8749c1abf08cdb1057b';

final class CalendarNotifierFamily extends $Family
    with
        $ClassFamilyOverride<CalendarNotifier, AsyncValue<List<AgendaModel>>,
            List<AgendaModel>, FutureOr<List<AgendaModel>>, DateTime> {
  CalendarNotifierFamily._()
      : super(
          retry: null,
          name: r'calendarProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CalendarNotifierProvider call(
    DateTime month,
  ) =>
      CalendarNotifierProvider._(argument: month, from: this);

  @override
  String toString() => r'calendarProvider';
}

abstract class _$CalendarNotifier extends $AsyncNotifier<List<AgendaModel>> {
  late final _$args = ref.$arg as DateTime;
  DateTime get month => _$args;

  FutureOr<List<AgendaModel>> build(
    DateTime month,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AgendaModel>>, List<AgendaModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<AgendaModel>>, List<AgendaModel>>,
        AsyncValue<List<AgendaModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
