// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content_repo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$textContentCacheHash() => r'187064cfac3d58086cde99f4cf3aaa58ad2040a4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [textContentCache].
@ProviderFor(textContentCache)
const textContentCacheProvider = TextContentCacheFamily();

/// See also [textContentCache].
class TextContentCacheFamily extends Family<TextContentCache> {
  /// See also [textContentCache].
  const TextContentCacheFamily();

  /// See also [textContentCache].
  TextContentCacheProvider call({required String key}) {
    return TextContentCacheProvider(key: key);
  }

  @override
  TextContentCacheProvider getProviderOverride(
    covariant TextContentCacheProvider provider,
  ) {
    return call(key: provider.key);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'textContentCacheProvider';
}

/// See also [textContentCache].
class TextContentCacheProvider extends AutoDisposeProvider<TextContentCache> {
  /// See also [textContentCache].
  TextContentCacheProvider({required String key})
    : this._internal(
        (ref) => textContentCache(ref as TextContentCacheRef, key: key),
        from: textContentCacheProvider,
        name: r'textContentCacheProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$textContentCacheHash,
        dependencies: TextContentCacheFamily._dependencies,
        allTransitiveDependencies:
            TextContentCacheFamily._allTransitiveDependencies,
        key: key,
      );

  TextContentCacheProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  Override overrideWith(
    TextContentCache Function(TextContentCacheRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TextContentCacheProvider._internal(
        (ref) => create(ref as TextContentCacheRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TextContentCache> createElement() {
    return _TextContentCacheProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TextContentCacheProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TextContentCacheRef on AutoDisposeProviderRef<TextContentCache> {
  /// The parameter `key` of this provider.
  String get key;
}

class _TextContentCacheProviderElement
    extends AutoDisposeProviderElement<TextContentCache>
    with TextContentCacheRef {
  _TextContentCacheProviderElement(super.provider);

  @override
  String get key => (origin as TextContentCacheProvider).key;
}

String _$practiceContentFetcherHash() =>
    r'e1a10de3a3ba326ee4a7fa2c01e4fafb6ea536e9';

/// Fetcher for practice content
///
/// Copied from [practiceContentFetcher].
@ProviderFor(practiceContentFetcher)
final practiceContentFetcherProvider =
    AutoDisposeProvider<TextContentFetcher>.internal(
      practiceContentFetcher,
      name: r'practiceContentFetcherProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$practiceContentFetcherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PracticeContentFetcherRef = AutoDisposeProviderRef<TextContentFetcher>;
String _$challengeContentFetcherHash() =>
    r'83c2bcf08386fb874feefcb1a46243968f3ce879';

/// Fetcher for challenge content
///
/// Copied from [challengeContentFetcher].
@ProviderFor(challengeContentFetcher)
final challengeContentFetcherProvider =
    AutoDisposeProvider<TextContentFetcher>.internal(
      challengeContentFetcher,
      name: r'challengeContentFetcherProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$challengeContentFetcherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChallengeContentFetcherRef = AutoDisposeProviderRef<TextContentFetcher>;
String _$practiceContentRepositoryHash() =>
    r'cd8746366d52481e7798aafca95495a036e091c2';

/// Repository for practice content
///
/// Copied from [practiceContentRepository].
@ProviderFor(practiceContentRepository)
final practiceContentRepositoryProvider =
    AutoDisposeProvider<TextContentRepository>.internal(
      practiceContentRepository,
      name: r'practiceContentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$practiceContentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PracticeContentRepositoryRef =
    AutoDisposeProviderRef<TextContentRepository>;
String _$challengeContentRepositoryHash() =>
    r'f172bbe33298cd6faeb99ee59e9d96330b79916f';

/// Repository for challenge content
///
/// Copied from [challengeContentRepository].
@ProviderFor(challengeContentRepository)
final challengeContentRepositoryProvider =
    AutoDisposeProvider<TextContentRepository>.internal(
      challengeContentRepository,
      name: r'challengeContentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$challengeContentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChallengeContentRepositoryRef =
    AutoDisposeProviderRef<TextContentRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
