// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable_expenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$variableExpensesRepositoryHash() =>
    r'08c8d2e5130e39fd86a9b665cd36f899ccade5c7';

/// See also [variableExpensesRepository].
@ProviderFor(variableExpensesRepository)
final variableExpensesRepositoryProvider =
    AutoDisposeProvider<VariableExpensesRepository>.internal(
  variableExpensesRepository,
  name: r'variableExpensesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$variableExpensesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VariableExpensesRepositoryRef
    = AutoDisposeProviderRef<VariableExpensesRepository>;
String _$variableExpensesStreamHash() =>
    r'c7e2682b16dec9fca98fd395015f396f68939457';

/// See also [variableExpensesStream].
@ProviderFor(variableExpensesStream)
final variableExpensesStreamProvider =
    AutoDisposeStreamProvider<List<VariableExpense>>.internal(
  variableExpensesStream,
  name: r'variableExpensesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$variableExpensesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VariableExpensesStreamRef
    = AutoDisposeStreamProviderRef<List<VariableExpense>>;
String _$selectedMonthHash() => r'699be852aa020a908de00d43afdec0f9c535f81a';

/// See also [SelectedMonth].
@ProviderFor(SelectedMonth)
final selectedMonthProvider =
    AutoDisposeNotifierProvider<SelectedMonth, DateTime>.internal(
  SelectedMonth.new,
  name: r'selectedMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedMonth = AutoDisposeNotifier<DateTime>;
String _$variableExpensesNotifierHash() =>
    r'33ab5cd0684a6a658f07b785a3f67ac4c6a85cba';

/// See also [VariableExpensesNotifier].
@ProviderFor(VariableExpensesNotifier)
final variableExpensesNotifierProvider = AutoDisposeNotifierProvider<
    VariableExpensesNotifier, AsyncValue<void>>.internal(
  VariableExpensesNotifier.new,
  name: r'variableExpensesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$variableExpensesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VariableExpensesNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
