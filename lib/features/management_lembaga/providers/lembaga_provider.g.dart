// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lembaga_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CabangList)
final cabangListProvider = CabangListProvider._();

final class CabangListProvider
    extends $AsyncNotifierProvider<CabangList, List<CabangModel>> {
  CabangListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cabangListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cabangListHash();

  @$internal
  @override
  CabangList create() => CabangList();
}

String _$cabangListHash() => r'dc1f3dc49512ec6c8a64bfb448c961cb927da0eb';

abstract class _$CabangList extends $AsyncNotifier<List<CabangModel>> {
  FutureOr<List<CabangModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CabangModel>>, List<CabangModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<CabangModel>>, List<CabangModel>>,
        AsyncValue<List<CabangModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DivisiList)
final divisiListProvider = DivisiListProvider._();

final class DivisiListProvider
    extends $AsyncNotifierProvider<DivisiList, List<DivisiModel>> {
  DivisiListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'divisiListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$divisiListHash();

  @$internal
  @override
  DivisiList create() => DivisiList();
}

String _$divisiListHash() => r'be8de99c61626140e9d9d6d8d7b54255e6246fb4';

abstract class _$DivisiList extends $AsyncNotifier<List<DivisiModel>> {
  FutureOr<List<DivisiModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DivisiModel>>, List<DivisiModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<DivisiModel>>, List<DivisiModel>>,
        AsyncValue<List<DivisiModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(JabatanList)
final jabatanListProvider = JabatanListProvider._();

final class JabatanListProvider
    extends $AsyncNotifierProvider<JabatanList, List<JabatanModel>> {
  JabatanListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'jabatanListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$jabatanListHash();

  @$internal
  @override
  JabatanList create() => JabatanList();
}

String _$jabatanListHash() => r'8ae4de93a4ef0dd2cabc3f8b266f3d0ce101e02d';

abstract class _$JabatanList extends $AsyncNotifier<List<JabatanModel>> {
  FutureOr<List<JabatanModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<JabatanModel>>, List<JabatanModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<JabatanModel>>, List<JabatanModel>>,
        AsyncValue<List<JabatanModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
