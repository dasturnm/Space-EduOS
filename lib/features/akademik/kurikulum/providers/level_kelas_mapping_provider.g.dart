// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_kelas_mapping_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LevelKelasMapping)
final levelKelasMappingProvider = LevelKelasMappingFamily._();

final class LevelKelasMappingProvider extends $AsyncNotifierProvider<
    LevelKelasMapping, List<Map<String, dynamic>>> {
  LevelKelasMappingProvider._(
      {required LevelKelasMappingFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'levelKelasMappingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$levelKelasMappingHash();

  @override
  String toString() {
    return r'levelKelasMappingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LevelKelasMapping create() => LevelKelasMapping();

  @override
  bool operator ==(Object other) {
    return other is LevelKelasMappingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$levelKelasMappingHash() => r'eb54a941680a95e9b5a066f68100003d7a45687e';

final class LevelKelasMappingFamily extends $Family
    with
        $ClassFamilyOverride<
            LevelKelasMapping,
            AsyncValue<List<Map<String, dynamic>>>,
            List<Map<String, dynamic>>,
            FutureOr<List<Map<String, dynamic>>>,
            String> {
  LevelKelasMappingFamily._()
      : super(
          retry: null,
          name: r'levelKelasMappingProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LevelKelasMappingProvider call(
    String levelId,
  ) =>
      LevelKelasMappingProvider._(argument: levelId, from: this);

  @override
  String toString() => r'levelKelasMappingProvider';
}

abstract class _$LevelKelasMapping
    extends $AsyncNotifier<List<Map<String, dynamic>>> {
  late final _$args = ref.$arg as String;
  String get levelId => _$args;

  FutureOr<List<Map<String, dynamic>>> build(
    String levelId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Map<String, dynamic>>>,
        List<Map<String, dynamic>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Map<String, dynamic>>>,
            List<Map<String, dynamic>>>,
        AsyncValue<List<Map<String, dynamic>>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
