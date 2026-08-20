// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kelas_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KelasSearch)
final kelasSearchProvider = KelasSearchProvider._();

final class KelasSearchProvider extends $NotifierProvider<KelasSearch, String> {
  KelasSearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kelasSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kelasSearchHash();

  @$internal
  @override
  KelasSearch create() => KelasSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$kelasSearchHash() => r'6482ecad19a96a6b1d9a50d8d3c2c1ca00601b69';

abstract class _$KelasSearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(KelasList)
final kelasListProvider = KelasListProvider._();

final class KelasListProvider
    extends $AsyncNotifierProvider<KelasList, List<KelasModel>> {
  KelasListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kelasListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kelasListHash();

  @$internal
  @override
  KelasList create() => KelasList();
}

String _$kelasListHash() => r'1c38e94f841e88dad3bc31a09ef479fc025e5baf';

abstract class _$KelasList extends $AsyncNotifier<List<KelasModel>> {
  FutureOr<List<KelasModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<KelasModel>>, List<KelasModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<KelasModel>>, List<KelasModel>>,
        AsyncValue<List<KelasModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(kelas)
final kelasProvider = KelasProvider._();

final class KelasProvider extends $FunctionalProvider<List<KelasModel>,
    List<KelasModel>, List<KelasModel>> with $Provider<List<KelasModel>> {
  KelasProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kelasProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kelasHash();

  @$internal
  @override
  $ProviderElement<List<KelasModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<KelasModel> create(Ref ref) {
    return kelas(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<KelasModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<KelasModel>>(value),
    );
  }
}

String _$kelasHash() => r'840ad65eb9bed6508e02dbf8a069dba3a345c7bd';
