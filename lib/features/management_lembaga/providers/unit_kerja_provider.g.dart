// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_kerja_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnitKerjaList)
final unitKerjaListProvider = UnitKerjaListProvider._();

final class UnitKerjaListProvider
    extends $AsyncNotifierProvider<UnitKerjaList, List<UnitKerjaModel>> {
  UnitKerjaListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unitKerjaListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unitKerjaListHash();

  @$internal
  @override
  UnitKerjaList create() => UnitKerjaList();
}

String _$unitKerjaListHash() => r'31d632995fb0766939c69c33c1562f27f5f8fae1';

abstract class _$UnitKerjaList extends $AsyncNotifier<List<UnitKerjaModel>> {
  FutureOr<List<UnitKerjaModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<UnitKerjaModel>>, List<UnitKerjaModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<UnitKerjaModel>>, List<UnitKerjaModel>>,
        AsyncValue<List<UnitKerjaModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
