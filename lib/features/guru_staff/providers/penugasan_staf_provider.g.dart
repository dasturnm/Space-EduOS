// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penugasan_staf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PenugasanStafList)
final penugasanStafListProvider = PenugasanStafListFamily._();

final class PenugasanStafListProvider extends $AsyncNotifierProvider<
    PenugasanStafList, List<PenugasanStafModel>> {
  PenugasanStafListProvider._(
      {required PenugasanStafListFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'penugasanStafListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$penugasanStafListHash();

  @override
  String toString() {
    return r'penugasanStafListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PenugasanStafList create() => PenugasanStafList();

  @override
  bool operator ==(Object other) {
    return other is PenugasanStafListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$penugasanStafListHash() => r'3280ed185e7b96345f4c5118d03ab954a2c4e66f';

final class PenugasanStafListFamily extends $Family
    with
        $ClassFamilyOverride<
            PenugasanStafList,
            AsyncValue<List<PenugasanStafModel>>,
            List<PenugasanStafModel>,
            FutureOr<List<PenugasanStafModel>>,
            String> {
  PenugasanStafListFamily._()
      : super(
          retry: null,
          name: r'penugasanStafListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PenugasanStafListProvider call(
    String lembagaId,
  ) =>
      PenugasanStafListProvider._(argument: lembagaId, from: this);

  @override
  String toString() => r'penugasanStafListProvider';
}

abstract class _$PenugasanStafList
    extends $AsyncNotifier<List<PenugasanStafModel>> {
  late final _$args = ref.$arg as String;
  String get lembagaId => _$args;

  FutureOr<List<PenugasanStafModel>> build(
    String lembagaId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<PenugasanStafModel>>, List<PenugasanStafModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PenugasanStafModel>>,
            List<PenugasanStafModel>>,
        AsyncValue<List<PenugasanStafModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(PenugasanStaf)
final penugasanStafProvider = PenugasanStafProvider._();

final class PenugasanStafProvider
    extends $NotifierProvider<PenugasanStaf, void> {
  PenugasanStafProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'penugasanStafProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$penugasanStafHash();

  @$internal
  @override
  PenugasanStaf create() => PenugasanStaf();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$penugasanStafHash() => r'0b27df2b8d5b1456474555e804e26b1ce1fde4f0';

abstract class _$PenugasanStaf extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
