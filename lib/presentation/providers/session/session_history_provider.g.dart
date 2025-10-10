// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionHistoryRepositoryHash() =>
    r'5d49587c29814fdd037dfbb9ac990bfda67c6870';

/// See also [sessionHistoryRepository].
@ProviderFor(sessionHistoryRepository)
final sessionHistoryRepositoryProvider =
    Provider<ISessionHistoryRepository>.internal(
      sessionHistoryRepository,
      name: r'sessionHistoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionHistoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionHistoryRepositoryRef = ProviderRef<ISessionHistoryRepository>;
String _$sessionHistoryHash() => r'abb37effa86ad367b24b6cf46b041dced10cd7ac';

/// Async cache of all sessions; refresh with `reload()` after changes.
///
/// Copied from [SessionHistory].
@ProviderFor(SessionHistory)
final sessionHistoryProvider =
    AsyncNotifierProvider<SessionHistory, List<TypingSession>>.internal(
      SessionHistory.new,
      name: r'sessionHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SessionHistory = AsyncNotifier<List<TypingSession>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
