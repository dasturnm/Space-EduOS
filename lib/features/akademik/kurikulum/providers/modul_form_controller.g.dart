// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modul_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ModulFormController)
final modulFormControllerProvider = ModulFormControllerFamily._();

final class ModulFormControllerProvider
    extends $NotifierProvider<ModulFormController, ModulFormState> {
  ModulFormControllerProvider._(
      {required ModulFormControllerFamily super.from,
      required (
        LevelModel,
        ModulModel?,
      )
          super.argument})
      : super(
          retry: null,
          name: r'modulFormControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modulFormControllerHash();

  @override
  String toString() {
    return r'modulFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ModulFormController create() => ModulFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModulFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModulFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ModulFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$modulFormControllerHash() =>
    r'188193cceab64ba342526ebb190f5baa31439978';

final class ModulFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            ModulFormController,
            ModulFormState,
            ModulFormState,
            ModulFormState,
            (
              LevelModel,
              ModulModel?,
            )> {
  ModulFormControllerFamily._()
      : super(
          retry: null,
          name: r'modulFormControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ModulFormControllerProvider call(
    LevelModel level,
    ModulModel? initialModul,
  ) =>
      ModulFormControllerProvider._(argument: (
        level,
        initialModul,
      ), from: this);

  @override
  String toString() => r'modulFormControllerProvider';
}

abstract class _$ModulFormController extends $Notifier<ModulFormState> {
  late final _$args = ref.$arg as (
    LevelModel,
    ModulModel?,
  );
  LevelModel get level => _$args.$1;
  ModulModel? get initialModul => _$args.$2;

  ModulFormState build(
    LevelModel level,
    ModulModel? initialModul,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ModulFormState, ModulFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ModulFormState, ModulFormState>,
        ModulFormState,
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
