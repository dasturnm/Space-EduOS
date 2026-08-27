// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuditLogNotifier)
final auditLogProvider = AuditLogNotifierFamily._();

final class AuditLogNotifierProvider
    extends $AsyncNotifierProvider<AuditLogNotifier, AuditLogState> {
  AuditLogNotifierProvider._(
      {required AuditLogNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'auditLogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$auditLogNotifierHash();

  @override
  String toString() {
    return r'auditLogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuditLogNotifier create() => AuditLogNotifier();

  @override
  bool operator ==(Object other) {
    return other is AuditLogNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$auditLogNotifierHash() => r'c09043bfab67602796e227b51f245e3596652b2c';

final class AuditLogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<AuditLogNotifier, AsyncValue<AuditLogState>,
            AuditLogState, FutureOr<AuditLogState>, String> {
  AuditLogNotifierFamily._()
      : super(
          retry: null,
          name: r'auditLogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AuditLogNotifierProvider call(
    String organizationId,
  ) =>
      AuditLogNotifierProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'auditLogProvider';
}

abstract class _$AuditLogNotifier extends $AsyncNotifier<AuditLogState> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<AuditLogState> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuditLogState>, AuditLogState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AuditLogState>, AuditLogState>,
        AsyncValue<AuditLogState>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
