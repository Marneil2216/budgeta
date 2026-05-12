// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_expenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fixedExpensesRepositoryHash() =>
    r'acbb40742039dd52fda5bc92560ebbc3277c2ba9';

/// See also [fixedExpensesRepository].
@ProviderFor(fixedExpensesRepository)
final fixedExpensesRepositoryProvider =
    AutoDisposeProvider<FixedExpensesRepository>.internal(
  fixedExpensesRepository,
  name: r'fixedExpensesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fixedExpensesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FixedExpensesRepositoryRef
    = AutoDisposeProviderRef<FixedExpensesRepository>;
String _$fixedExpensesStreamHash() =>
    r'd487a83ab162dcbcc1f552ffbfe9a3355a54214b';

/// See also [fixedExpensesStream].
@ProviderFor(fixedExpensesStream)
final fixedExpensesStreamProvider =
    AutoDisposeStreamProvider<List<FixedExpense>>.internal(
  fixedExpensesStream,
  name: r'fixedExpensesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fixedExpensesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FixedExpensesStreamRef
    = AutoDisposeStreamProviderRef<List<FixedExpense>>;
String _$fixedExpensesNotifierHash() =>
    r'f743d6d30744efa58634458b768d8917dae2e2b4';

/// See also [FixedExpensesNotifier].
@ProviderFor(FixedExpensesNotifier)
final fixedExpensesNotifierProvider = AutoDisposeNotifierProvider<
    FixedExpensesNotifier, AsyncValue<void>>.internal(
  FixedExpensesNotifier.new,
  name: r'fixedExpensesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fixedExpensesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FixedExpensesNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
