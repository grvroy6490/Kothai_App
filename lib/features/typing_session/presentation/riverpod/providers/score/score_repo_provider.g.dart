// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_repo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scoreDaoHash() => r'8df1658aaba63b0b4af4061a474d30f16b3b36b3';

/// See also [scoreDao].
@ProviderFor(scoreDao)
final scoreDaoProvider = AutoDisposeProvider<ScoreDao>.internal(
  scoreDao,
  name: r'scoreDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scoreDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScoreDaoRef = AutoDisposeProviderRef<ScoreDao>;
String _$scoreLocalRepositoryHash() =>
    r'1bb9cc1256b02cd76e960ae4de8b4e661ebad2ba';

/// See also [scoreLocalRepository].
@ProviderFor(scoreLocalRepository)
final scoreLocalRepositoryProvider =
    AutoDisposeProvider<ScoreLocalDBRepository>.internal(
      scoreLocalRepository,
      name: r'scoreLocalRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scoreLocalRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScoreLocalRepositoryRef =
    AutoDisposeProviderRef<ScoreLocalDBRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
