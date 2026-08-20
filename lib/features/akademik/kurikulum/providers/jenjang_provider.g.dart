// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenjang_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JenjangList)
final jenjangListProvider = JenjangListFamily._();

final class JenjangListProvider
    extends $AsyncNotifierProvider<JenjangList, List<JenjangModel>> {
  JenjangListProvider._(
      {required JenjangListFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'jenjangListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$jenjangListHash();

  @override
  String toString() {
    return r'jenjangListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  JenjangList create() => JenjangList();

  @override
  bool operator ==(Object other) {
    return other is JenjangListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jenjangListHash() => r'af11627759602ac7632b4cfccec7fe47ce5286d2';

final class JenjangListFamily extends $Family
    with
        $ClassFamilyOverride<JenjangList, AsyncValue<List<JenjangModel>>,
            List<JenjangModel>, FutureOr<List<JenjangModel>>, String> {
  JenjangListFamily._()
      : super(
          retry: null,
          name: r'jenjangListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  JenjangListProvider call(
    String kurikulumId,
  ) =>
      JenjangListProvider._(argument: kurikulumId, from: this);

  @override
  String toString() => r'jenjangListProvider';
}

abstract class _$JenjangList extends $AsyncNotifier<List<JenjangModel>> {
  late final _$args = ref.$arg as String;
  String get kurikulumId => _$args;

  FutureOr<List<JenjangModel>> build(
    String kurikulumId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<JenjangModel>>, List<JenjangModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<JenjangModel>>, List<JenjangModel>>,
        AsyncValue<List<JenjangModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
