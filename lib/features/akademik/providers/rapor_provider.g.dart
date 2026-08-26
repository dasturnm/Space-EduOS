// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rapor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(raporEngineService)
final raporEngineServiceProvider = RaporEngineServiceProvider._();

final class RaporEngineServiceProvider extends $FunctionalProvider<
    RaporEngineService,
    RaporEngineService,
    RaporEngineService> with $Provider<RaporEngineService> {
  RaporEngineServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'raporEngineServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$raporEngineServiceHash();

  @$internal
  @override
  $ProviderElement<RaporEngineService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RaporEngineService create(Ref ref) {
    return raporEngineService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RaporEngineService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RaporEngineService>(value),
    );
  }
}

String _$raporEngineServiceHash() =>
    r'1889650f16acf635a12e58c3d3da6010428675b0';

@ProviderFor(RaporNotifier)
final raporProvider = RaporNotifierFamily._();

final class RaporNotifierProvider
    extends $AsyncNotifierProvider<RaporNotifier, RaporModel> {
  RaporNotifierProvider._(
      {required RaporNotifierFamily super.from,
      required (
        String,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'raporProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$raporNotifierHash();

  @override
  String toString() {
    return r'raporProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RaporNotifier create() => RaporNotifier();

  @override
  bool operator ==(Object other) {
    return other is RaporNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$raporNotifierHash() => r'ba12a72b5d7e83ededb48f614690624175106ac3';

final class RaporNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            RaporNotifier,
            AsyncValue<RaporModel>,
            RaporModel,
            FutureOr<RaporModel>,
            (
              String,
              String,
            )> {
  RaporNotifierFamily._()
      : super(
          retry: null,
          name: r'raporProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RaporNotifierProvider call(
    String studentId,
    String termId,
  ) =>
      RaporNotifierProvider._(argument: (
        studentId,
        termId,
      ), from: this);

  @override
  String toString() => r'raporProvider';
}

abstract class _$RaporNotifier extends $AsyncNotifier<RaporModel> {
  late final _$args = ref.$arg as (
    String,
    String,
  );
  String get studentId => _$args.$1;
  String get termId => _$args.$2;

  FutureOr<RaporModel> build(
    String studentId,
    String termId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RaporModel>, RaporModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<RaporModel>, RaporModel>,
        AsyncValue<RaporModel>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}
