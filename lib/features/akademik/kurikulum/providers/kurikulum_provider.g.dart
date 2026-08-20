// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kurikulum_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KurikulumList)
final kurikulumListProvider = KurikulumListFamily._();

final class KurikulumListProvider
    extends $AsyncNotifierProvider<KurikulumList, List<KurikulumModel>> {
  KurikulumListProvider._(
      {required KurikulumListFamily super.from,
      required (
        String, {
        String search,
        String status,
        String? programId,
        String? tahunAjaranId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'kurikulumListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kurikulumListHash();

  @override
  String toString() {
    return r'kurikulumListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  KurikulumList create() => KurikulumList();

  @override
  bool operator ==(Object other) {
    return other is KurikulumListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kurikulumListHash() => r'af8c2461ee2f05261faf2e3ab550f064004a5413';

final class KurikulumListFamily extends $Family
    with
        $ClassFamilyOverride<
            KurikulumList,
            AsyncValue<List<KurikulumModel>>,
            List<KurikulumModel>,
            FutureOr<List<KurikulumModel>>,
            (
              String, {
              String search,
              String status,
              String? programId,
              String? tahunAjaranId,
            })> {
  KurikulumListFamily._()
      : super(
          retry: null,
          name: r'kurikulumListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  KurikulumListProvider call(
    String lembagaId, {
    String search = '',
    String status = 'Semua',
    String? programId,
    String? tahunAjaranId,
  }) =>
      KurikulumListProvider._(argument: (
        lembagaId,
        search: search,
        status: status,
        programId: programId,
        tahunAjaranId: tahunAjaranId,
      ), from: this);

  @override
  String toString() => r'kurikulumListProvider';
}

abstract class _$KurikulumList extends $AsyncNotifier<List<KurikulumModel>> {
  late final _$args = ref.$arg as (
    String, {
    String search,
    String status,
    String? programId,
    String? tahunAjaranId,
  });
  String get lembagaId => _$args.$1;
  String get search => _$args.search;
  String get status => _$args.status;
  String? get programId => _$args.programId;
  String? get tahunAjaranId => _$args.tahunAjaranId;

  FutureOr<List<KurikulumModel>> build(
    String lembagaId, {
    String search = '',
    String status = 'Semua',
    String? programId,
    String? tahunAjaranId,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<KurikulumModel>>, List<KurikulumModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<KurikulumModel>>, List<KurikulumModel>>,
        AsyncValue<List<KurikulumModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              search: _$args.search,
              status: _$args.status,
              programId: _$args.programId,
              tahunAjaranId: _$args.tahunAjaranId,
            ));
  }
}

@ProviderFor(kurikulumService)
final kurikulumServiceProvider = KurikulumServiceProvider._();

final class KurikulumServiceProvider extends $FunctionalProvider<
    KurikulumService,
    KurikulumService,
    KurikulumService> with $Provider<KurikulumService> {
  KurikulumServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kurikulumServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kurikulumServiceHash();

  @$internal
  @override
  $ProviderElement<KurikulumService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KurikulumService create(Ref ref) {
    return kurikulumService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KurikulumService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KurikulumService>(value),
    );
  }
}

String _$kurikulumServiceHash() => r'ff25707b1cdc8f596f712a063a0ebf3e14aa0029';

@ProviderFor(kurikulumByProgram)
final kurikulumByProgramProvider = KurikulumByProgramFamily._();

final class KurikulumByProgramProvider extends $FunctionalProvider<
        AsyncValue<List<KurikulumModel>>,
        List<KurikulumModel>,
        FutureOr<List<KurikulumModel>>>
    with
        $FutureModifier<List<KurikulumModel>>,
        $FutureProvider<List<KurikulumModel>> {
  KurikulumByProgramProvider._(
      {required KurikulumByProgramFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'kurikulumByProgramProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kurikulumByProgramHash();

  @override
  String toString() {
    return r'kurikulumByProgramProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<KurikulumModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<KurikulumModel>> create(Ref ref) {
    final argument = this.argument as String?;
    return kurikulumByProgram(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KurikulumByProgramProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kurikulumByProgramHash() =>
    r'7cffa5e06603514cfea1332f0911c9a977bf140c';

final class KurikulumByProgramFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<KurikulumModel>>, String?> {
  KurikulumByProgramFamily._()
      : super(
          retry: null,
          name: r'kurikulumByProgramProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  KurikulumByProgramProvider call(
    String? programId,
  ) =>
      KurikulumByProgramProvider._(argument: programId, from: this);

  @override
  String toString() => r'kurikulumByProgramProvider';
}

@ProviderFor(levelsByKurikulum)
final levelsByKurikulumProvider = LevelsByKurikulumFamily._();

final class LevelsByKurikulumProvider extends $FunctionalProvider<
        AsyncValue<List<LevelModel>>,
        List<LevelModel>,
        FutureOr<List<LevelModel>>>
    with $FutureModifier<List<LevelModel>>, $FutureProvider<List<LevelModel>> {
  LevelsByKurikulumProvider._(
      {required LevelsByKurikulumFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'levelsByKurikulumProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$levelsByKurikulumHash();

  @override
  String toString() {
    return r'levelsByKurikulumProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LevelModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<LevelModel>> create(Ref ref) {
    final argument = this.argument as String?;
    return levelsByKurikulum(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LevelsByKurikulumProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$levelsByKurikulumHash() => r'7acec7abeafc1fd814f522aab77331f95095e042';

final class LevelsByKurikulumFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LevelModel>>, String?> {
  LevelsByKurikulumFamily._()
      : super(
          retry: null,
          name: r'levelsByKurikulumProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LevelsByKurikulumProvider call(
    String? kurikulumId,
  ) =>
      LevelsByKurikulumProvider._(argument: kurikulumId, from: this);

  @override
  String toString() => r'levelsByKurikulumProvider';
}

@ProviderFor(modulByLevel)
final modulByLevelProvider = ModulByLevelFamily._();

final class ModulByLevelProvider extends $FunctionalProvider<
        AsyncValue<List<ModulModel>>,
        List<ModulModel>,
        FutureOr<List<ModulModel>>>
    with $FutureModifier<List<ModulModel>>, $FutureProvider<List<ModulModel>> {
  ModulByLevelProvider._(
      {required ModulByLevelFamily super.from, required String? super.argument})
      : super(
          retry: null,
          name: r'modulByLevelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modulByLevelHash();

  @override
  String toString() {
    return r'modulByLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ModulModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ModulModel>> create(Ref ref) {
    final argument = this.argument as String?;
    return modulByLevel(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ModulByLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$modulByLevelHash() => r'1c3be1a96e037ea72909f809343c648b27f2f978';

final class ModulByLevelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ModulModel>>, String?> {
  ModulByLevelFamily._()
      : super(
          retry: null,
          name: r'modulByLevelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ModulByLevelProvider call(
    String? levelId,
  ) =>
      ModulByLevelProvider._(argument: levelId, from: this);

  @override
  String toString() => r'modulByLevelProvider';
}
