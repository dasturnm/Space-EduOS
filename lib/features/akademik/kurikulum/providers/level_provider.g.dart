// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LevelList)
final levelListProvider = LevelListFamily._();

final class LevelListProvider
    extends $AsyncNotifierProvider<LevelList, List<LevelModel>> {
  LevelListProvider._(
      {required LevelListFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'levelListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$levelListHash();

  @override
  String toString() {
    return r'levelListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LevelList create() => LevelList();

  @override
  bool operator ==(Object other) {
    return other is LevelListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$levelListHash() => r'1230bfbe7218535b65cd9aba594509727b656f19';

final class LevelListFamily extends $Family
    with
        $ClassFamilyOverride<LevelList, AsyncValue<List<LevelModel>>,
            List<LevelModel>, FutureOr<List<LevelModel>>, String> {
  LevelListFamily._()
      : super(
          retry: null,
          name: r'levelListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LevelListProvider call(
    String jenjangId,
  ) =>
      LevelListProvider._(argument: jenjangId, from: this);

  @override
  String toString() => r'levelListProvider';
}

abstract class _$LevelList extends $AsyncNotifier<List<LevelModel>> {
  late final _$args = ref.$arg as String;
  String get jenjangId => _$args;

  FutureOr<List<LevelModel>> build(
    String jenjangId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LevelModel>>, List<LevelModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<LevelModel>>, List<LevelModel>>,
        AsyncValue<List<LevelModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(LevelsByProgram)
final levelsByProgramProvider = LevelsByProgramFamily._();

final class LevelsByProgramProvider
    extends $AsyncNotifierProvider<LevelsByProgram, List<LevelModel>> {
  LevelsByProgramProvider._(
      {required LevelsByProgramFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'levelsByProgramProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$levelsByProgramHash();

  @override
  String toString() {
    return r'levelsByProgramProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LevelsByProgram create() => LevelsByProgram();

  @override
  bool operator ==(Object other) {
    return other is LevelsByProgramProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$levelsByProgramHash() => r'bdd0f7ed88364df9b569ce9da3d883a1feec7e52';

final class LevelsByProgramFamily extends $Family
    with
        $ClassFamilyOverride<LevelsByProgram, AsyncValue<List<LevelModel>>,
            List<LevelModel>, FutureOr<List<LevelModel>>, String?> {
  LevelsByProgramFamily._()
      : super(
          retry: null,
          name: r'levelsByProgramProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LevelsByProgramProvider call(
    String? programId,
  ) =>
      LevelsByProgramProvider._(argument: programId, from: this);

  @override
  String toString() => r'levelsByProgramProvider';
}

abstract class _$LevelsByProgram extends $AsyncNotifier<List<LevelModel>> {
  late final _$args = ref.$arg as String?;
  String? get programId => _$args;

  FutureOr<List<LevelModel>> build(
    String? programId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LevelModel>>, List<LevelModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<LevelModel>>, List<LevelModel>>,
        AsyncValue<List<LevelModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
