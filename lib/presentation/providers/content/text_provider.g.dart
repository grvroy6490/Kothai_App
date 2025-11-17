// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$textApiServiceHash() => r'21036ec66902099e199796879191601aefda42a0';

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
String _$textRepositoryHash() => r'146ecfb06f4a2b3dc14de52417d49dd5179c246e';

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
    r'b4bfca09fcac8ee85e8d87ccc1171c652dc08004';

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
String _$preloadedTextHash() => r'a0efc98003498c21c6d8ba87462c95e33b41b5e3';

/// See also [preloadedText].
@ProviderFor(preloadedText)
final preloadedTextProvider =
    AutoDisposeFutureProvider<List<TextParagraph>>.internal(
      preloadedText,
      name: r'preloadedTextProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preloadedTextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreloadedTextRef = AutoDisposeFutureProviderRef<List<TextParagraph>>;
String _$textContentHash() => r'1c6d5e7debe0f9a896fd48a5bc52d2270c390e3b';

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
