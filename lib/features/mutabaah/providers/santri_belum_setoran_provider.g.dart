// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santri_belum_setoran_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(santriBelumSetoran)
final santriBelumSetoranProvider = SantriBelumSetoranFamily._();

final class SantriBelumSetoranProvider extends $FunctionalProvider<
        AsyncValue<List<SiswaModel>>,
        List<SiswaModel>,
        FutureOr<List<SiswaModel>>>
    with $FutureModifier<List<SiswaModel>>, $FutureProvider<List<SiswaModel>> {
  SantriBelumSetoranProvider._(
      {required SantriBelumSetoranFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'santriBelumSetoranProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$santriBelumSetoranHash();

  @override
  String toString() {
    return r'santriBelumSetoranProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SiswaModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SiswaModel>> create(Ref ref) {
    final argument = this.argument as String;
    return santriBelumSetoran(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SantriBelumSetoranProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$santriBelumSetoranHash() =>
    r'f10fa872a58e00969485ce95d1f5215ca005628c';

final class SantriBelumSetoranFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SiswaModel>>, String> {
  SantriBelumSetoranFamily._()
      : super(
          retry: null,
          name: r'santriBelumSetoranProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SantriBelumSetoranProvider call(
    String guruId,
  ) =>
      SantriBelumSetoranProvider._(argument: guruId, from: this);

  @override
  String toString() => r'santriBelumSetoranProvider';
}
