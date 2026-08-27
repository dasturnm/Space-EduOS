// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatNotifier)
final aiChatProvider = AiChatNotifierFamily._();

final class AiChatNotifierProvider
    extends $AsyncNotifierProvider<AiChatNotifier, AiChatState> {
  AiChatNotifierProvider._(
      {required AiChatNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'aiChatProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiChatNotifierHash();

  @override
  String toString() {
    return r'aiChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AiChatNotifier create() => AiChatNotifier();

  @override
  bool operator ==(Object other) {
    return other is AiChatNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiChatNotifierHash() => r'dcac248df1d03d8520bafbbfd4a4076b4a6a1b78';

final class AiChatNotifierFamily extends $Family
    with
        $ClassFamilyOverride<AiChatNotifier, AsyncValue<AiChatState>,
            AiChatState, FutureOr<AiChatState>, String> {
  AiChatNotifierFamily._()
      : super(
          retry: null,
          name: r'aiChatProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AiChatNotifierProvider call(
    String organizationId,
  ) =>
      AiChatNotifierProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'aiChatProvider';
}

abstract class _$AiChatNotifier extends $AsyncNotifier<AiChatState> {
  late final _$args = ref.$arg as String;
  String get organizationId => _$args;

  FutureOr<AiChatState> build(
    String organizationId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AiChatState>, AiChatState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AiChatState>, AiChatState>,
        AsyncValue<AiChatState>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
