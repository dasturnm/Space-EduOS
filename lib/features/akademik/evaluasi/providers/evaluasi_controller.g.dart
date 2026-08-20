// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluasi_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EvaluasiController)
final evaluasiControllerProvider = EvaluasiControllerProvider._();

final class EvaluasiControllerProvider
    extends $AsyncNotifierProvider<EvaluasiController, void> {
  EvaluasiControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'evaluasiControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$evaluasiControllerHash();

  @$internal
  @override
  EvaluasiController create() => EvaluasiController();
}

String _$evaluasiControllerHash() =>
    r'3d35af26699502b2385af18c7a41f8630d184b35';

abstract class _$EvaluasiController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
