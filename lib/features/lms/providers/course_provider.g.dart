// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lmsService)
final lmsServiceProvider = LmsServiceProvider._();

final class LmsServiceProvider
    extends $FunctionalProvider<LmsService, LmsService, LmsService>
    with $Provider<LmsService> {
  LmsServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lmsServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lmsServiceHash();

  @$internal
  @override
  $ProviderElement<LmsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LmsService create(Ref ref) {
    return lmsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LmsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LmsService>(value),
    );
  }
}

String _$lmsServiceHash() => r'dbdf70a8aad313c084873db6deb11ae3e6e3ffc5';

@ProviderFor(CourseNotifier)
final courseProvider = CourseNotifierFamily._();

final class CourseNotifierProvider
    extends $AsyncNotifierProvider<CourseNotifier, List<CourseModel>> {
  CourseNotifierProvider._(
      {required CourseNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'courseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$courseNotifierHash();

  @override
  String toString() {
    return r'courseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CourseNotifier create() => CourseNotifier();

  @override
  bool operator ==(Object other) {
    return other is CourseNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseNotifierHash() => r'3dd751c063ebe1b65b6ba929df17a75011d614aa';

final class CourseNotifierFamily extends $Family
    with
        $ClassFamilyOverride<CourseNotifier, AsyncValue<List<CourseModel>>,
            List<CourseModel>, FutureOr<List<CourseModel>>, String> {
  CourseNotifierFamily._()
      : super(
          retry: null,
          name: r'courseProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CourseNotifierProvider call(
    String organizationId,
  ) =>
      CourseNotifierProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'courseProvider';
}

abstract class _$CourseNotifier extends $AsyncNotifier<List<CourseModel>> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<List<CourseModel>> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CourseModel>>, List<CourseModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<CourseModel>>, List<CourseModel>>,
        AsyncValue<List<CourseModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
