// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffSearch)
final staffSearchProvider = StaffSearchProvider._();

final class StaffSearchProvider extends $NotifierProvider<StaffSearch, String> {
  StaffSearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'staffSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$staffSearchHash();

  @$internal
  @override
  StaffSearch create() => StaffSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$staffSearchHash() => r'e93a7d5305fbe4e921535d71501c456d3368c2a5';

abstract class _$StaffSearch extends $Notifier<String> {
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

@ProviderFor(StaffList)
final staffListProvider = StaffListProvider._();

final class StaffListProvider
    extends $AsyncNotifierProvider<StaffList, List<ProfileModel>> {
  StaffListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'staffListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$staffListHash();

  @$internal
  @override
  StaffList create() => StaffList();
}

String _$staffListHash() => r'4063c7b0bf12619250f39d34766e06f85eaea429';

abstract class _$StaffList extends $AsyncNotifier<List<ProfileModel>> {
  FutureOr<List<ProfileModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ProfileModel>>, List<ProfileModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ProfileModel>>, List<ProfileModel>>,
        AsyncValue<List<ProfileModel>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
