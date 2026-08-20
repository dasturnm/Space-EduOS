// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modul_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ModulList)
final modulListProvider = ModulListFamily._();

final class ModulListProvider
    extends $AsyncNotifierProvider<ModulList, List<ModulModel>> {
  ModulListProvider._(
      {required ModulListFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'modulListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modulListHash();

  @override
  String toString() {
    return r'modulListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ModulList create() => ModulList();

  @override
  bool operator ==(Object other) {
    return other is ModulListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$modulListHash() => r'd209e6eb769488e310c3a73e029b410190fab56f';

final class ModulListFamily extends $Family
    with
        $ClassFamilyOverride<ModulList, AsyncValue<List<ModulModel>>,
            List<ModulModel>, FutureOr<List<ModulModel>>, String> {
  ModulListFamily._()
      : super(
          retry: null,
          name: r'modulListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ModulListProvider call(
    String levelId,
  ) =>
      ModulListProvider._(argument: levelId, from: this);

  @override
  String toString() => r'modulListProvider';
}

abstract class _$ModulList extends $AsyncNotifier<List<ModulModel>> {
  late final _$args = ref.$arg as String;
  String get levelId => _$args;

  FutureOr<List<ModulModel>> build(
    String levelId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ModulModel>>, List<ModulModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ModulModel>>, List<ModulModel>>,
        AsyncValue<List<ModulModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
