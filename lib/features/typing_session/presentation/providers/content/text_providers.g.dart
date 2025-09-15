// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$textApiServiceHash() => r'3163d951f26ac624372ca407bf3aec068a60cf29';

/// See also [textApiService].
@ProviderFor(textApiService)
final textApiServiceProvider = AutoDisposeProvider<TextApiService>.internal(
  textApiService,
  name: r'textApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$textApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TextApiServiceRef = AutoDisposeProviderRef<TextApiService>;
String _$assetTextsSourceHash() => r'f34f901dfbb24353abe2330479517d82f18c59ed';

/// See also [assetTextsSource].
@ProviderFor(assetTextsSource)
final assetTextsSourceProvider = AutoDisposeProvider<AssetTextsSource>.internal(
  assetTextsSource,
  name: r'assetTextsSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetTextsSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetTextsSourceRef = AutoDisposeProviderRef<AssetTextsSource>;
String _$textCacheHash() => r'044c74a7bd8b03bda5e943bad09390c8b8a411d7';

/// See also [textCache].
@ProviderFor(textCache)
final textCacheProvider = AutoDisposeProvider<TextCache>.internal(
  textCache,
  name: r'textCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$textCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TextCacheRef = AutoDisposeProviderRef<TextCache>;
String _$textRepositoryHash() => r'722eaac8bcfd7e7c744b065c1535468e72403ded';

/// See also [textRepository].
@ProviderFor(textRepository)
final textRepositoryProvider = AutoDisposeProvider<TextRepository>.internal(
  textRepository,
  name: r'textRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$textRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TextRepositoryRef = AutoDisposeProviderRef<TextRepository>;
String _$preloadTypingTextsHash() =>
    r'7d46c5f3469be2ac3be18464541b3c1464cfece4';

/// See also [preloadTypingTexts].
@ProviderFor(preloadTypingTexts)
final preloadTypingTextsProvider =
    AutoDisposeProvider<PreloadTypingTexts>.internal(
      preloadTypingTexts,
      name: r'preloadTypingTextsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preloadTypingTextsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreloadTypingTextsRef = AutoDisposeProviderRef<PreloadTypingTexts>;
String _$preloadedTextsHash() => r'34de41970d903d6691228fe09c513739a98b1a3c';

/// See also [preloadedTexts].
@ProviderFor(preloadedTexts)
final preloadedTextsProvider =
    AutoDisposeFutureProvider<List<TextParagraph>>.internal(
      preloadedTexts,
      name: r'preloadedTextsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preloadedTextsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreloadedTextsRef = AutoDisposeFutureProviderRef<List<TextParagraph>>;
String _$textContentHash() => r'b842f4e3ba271fe5047ef12b1ea401807e48039f';

/// See also [TextContent].
@ProviderFor(TextContent)
final textContentProvider =
    AutoDisposeNotifierProvider<TextContent, TextParagraph?>.internal(
      TextContent.new,
      name: r'textContentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$textContentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TextContent = AutoDisposeNotifier<TextParagraph?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
