// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tahun_ajaran_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TahunAjaranList)
final tahunAjaranListProvider = TahunAjaranListProvider._();

final class TahunAjaranListProvider
    extends $AsyncNotifierProvider<TahunAjaranList, List<TahunAjaranModel>> {
  TahunAjaranListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tahunAjaranListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tahunAjaranListHash();

  @$internal
  @override
  TahunAjaranList create() => TahunAjaranList();
}

String _$tahunAjaranListHash() => r'70542b634833023853901aead727a41c317c4c34';

abstract class _$TahunAjaranList
    extends $AsyncNotifier<List<TahunAjaranModel>> {
  FutureOr<List<TahunAjaranModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<TahunAjaranModel>>, List<TahunAjaranModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<TahunAjaranModel>>, List<TahunAjaranModel>>,
        AsyncValue<List<TahunAjaranModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
