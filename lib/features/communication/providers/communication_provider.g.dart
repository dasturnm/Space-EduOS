// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(communicationService)
final communicationServiceProvider = CommunicationServiceProvider._();

final class CommunicationServiceProvider extends $FunctionalProvider<
    CommunicationService,
    CommunicationService,
    CommunicationService> with $Provider<CommunicationService> {
  CommunicationServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'communicationServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$communicationServiceHash();

  @$internal
  @override
  $ProviderElement<CommunicationService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommunicationService create(Ref ref) {
    return communicationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunicationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommunicationService>(value),
    );
  }
}

String _$communicationServiceHash() =>
    r'35a54d17bc1f284f6941ecfb1a20f8b30527386b';

@ProviderFor(AnnouncementNotifier)
final announcementProvider = AnnouncementNotifierFamily._();

final class AnnouncementNotifierProvider extends $AsyncNotifierProvider<
    AnnouncementNotifier, List<AnnouncementModel>> {
  AnnouncementNotifierProvider._(
      {required AnnouncementNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'announcementProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementNotifierHash();

  @override
  String toString() {
    return r'announcementProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnnouncementNotifier create() => AnnouncementNotifier();

  @override
  bool operator ==(Object other) {
    return other is AnnouncementNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$announcementNotifierHash() =>
    r'63d1da5a64d0e5344f11384553ceb63b4195ce68';

final class AnnouncementNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            AnnouncementNotifier,
            AsyncValue<List<AnnouncementModel>>,
            List<AnnouncementModel>,
            FutureOr<List<AnnouncementModel>>,
            String> {
  AnnouncementNotifierFamily._()
      : super(
          retry: null,
          name: r'announcementProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AnnouncementNotifierProvider call(
    String organizationId,
  ) =>
      AnnouncementNotifierProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'announcementProvider';
}

abstract class _$AnnouncementNotifier
    extends $AsyncNotifier<List<AnnouncementModel>> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<List<AnnouncementModel>> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<AnnouncementModel>>, List<AnnouncementModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<AnnouncementModel>>,
            List<AnnouncementModel>>,
        AsyncValue<List<AnnouncementModel>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(inboxStream)
final inboxStreamProvider = InboxStreamFamily._();

final class InboxStreamProvider extends $FunctionalProvider<
        AsyncValue<List<NotificationModel>>,
        List<NotificationModel>,
        Stream<List<NotificationModel>>>
    with
        $FutureModifier<List<NotificationModel>>,
        $StreamProvider<List<NotificationModel>> {
  InboxStreamProvider._(
      {required InboxStreamFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'inboxStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$inboxStreamHash();

  @override
  String toString() {
    return r'inboxStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<NotificationModel>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationModel>> create(Ref ref) {
    final argument = this.argument as String;
    return inboxStream(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InboxStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inboxStreamHash() => r'6e0861296732555910511c06d17c683a8770685e';

final class InboxStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<NotificationModel>>, String> {
  InboxStreamFamily._()
      : super(
          retry: null,
          name: r'inboxStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  InboxStreamProvider call(
    String userId,
  ) =>
      InboxStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'inboxStreamProvider';
}
