// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AgendaNotifier)
final agendaProvider = AgendaNotifierFamily._();

final class AgendaNotifierProvider
    extends $AsyncNotifierProvider<AgendaNotifier, List<AgendaModel>> {
  AgendaNotifierProvider._(
      {required AgendaNotifierFamily super.from,
      required (
        String?,
        String?,
      )
          super.argument})
      : super(
          retry: null,
          name: r'agendaProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$agendaNotifierHash();

  @override
  String toString() {
    return r'agendaProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AgendaNotifier create() => AgendaNotifier();

  @override
  bool operator ==(Object other) {
    return other is AgendaNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$agendaNotifierHash() => r'7eb5aeb0f014f7d5ce030f2d802ffaec025efbdf';

final class AgendaNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            AgendaNotifier,
            AsyncValue<List<AgendaModel>>,
            List<AgendaModel>,
            FutureOr<List<AgendaModel>>,
            (
              String?,
              String?,
            )> {
  AgendaNotifierFamily._()
      : super(
          retry: null,
          name: r'agendaProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AgendaNotifierProvider call(
    String? tahunAjaranId,
    String? programId,
  ) =>
      AgendaNotifierProvider._(argument: (
        tahunAjaranId,
        programId,
      ), from: this);

  @override
  String toString() => r'agendaProvider';
}

abstract class _$AgendaNotifier extends $AsyncNotifier<List<AgendaModel>> {
  late final _$args = ref.$arg as (
    String?,
    String?,
  );
  String? get tahunAjaranId => _$args.$1;
  String? get programId => _$args.$2;

  FutureOr<List<AgendaModel>> build(
    String? tahunAjaranId,
    String? programId,
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
              _$args.$1,
              _$args.$2,
            ));
  }
}
