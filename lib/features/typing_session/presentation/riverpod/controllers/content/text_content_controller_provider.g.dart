// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentContentTypeHash() =>
    r'de57b1c4ef5c053f23b004520efa7e21278e179c';

/// Determines content type based on current session mode
///
/// Copied from [currentContentType].
@ProviderFor(currentContentType)
final currentContentTypeProvider =
    AutoDisposeProvider<ContentTypeEnum>.internal(
      currentContentType,
      name: r'currentContentTypeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentContentTypeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentContentTypeRef = AutoDisposeProviderRef<ContentTypeEnum>;
String _$currentContentRepositoryHash() =>
    r'9363be6f3a9073183bd62a0f7353bd414e8ee4b9';

/// Gets the appropriate repository based on current content type
///
/// Copied from [currentContentRepository].
@ProviderFor(currentContentRepository)
final currentContentRepositoryProvider =
    AutoDisposeProvider<TextContentRepository>.internal(
      currentContentRepository,
      name: r'currentContentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentContentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentContentRepositoryRef =
    AutoDisposeProviderRef<TextContentRepository>;
String _$getRandomizedContentHash() =>
    r'4c29d4b76d839b44cb0ae6c8e10f2c0a0b2c67c1';

/// See also [getRandomizedContent].
@ProviderFor(getRandomizedContent)
final getRandomizedContentProvider =
    AutoDisposeFutureProvider<List<TextContent>>.internal(
      getRandomizedContent,
      name: r'getRandomizedContentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getRandomizedContentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRandomizedContentRef =
    AutoDisposeFutureProviderRef<List<TextContent>>;
String _$getPreloadedTextsHash() => r'81c9b34409ad7cd6490bbcf60dbbbf7bdaac59a6';

/// See also [getPreloadedTexts].
@ProviderFor(getPreloadedTexts)
final getPreloadedTextsProvider =
    AutoDisposeFutureProvider<List<TextContent>>.internal(
      getPreloadedTexts,
      name: r'getPreloadedTextsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getPreloadedTextsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPreloadedTextsRef = AutoDisposeFutureProviderRef<List<TextContent>>;
String _$textContentControllerHash() =>
    r'91bd8a51691644b12cd4dc66b4af8ee3a04d83f2';

/// See also [TextContentController].
@ProviderFor(TextContentController)
final textContentControllerProvider =
    AutoDisposeNotifierProvider<TextContentController, TextContent?>.internal(
      TextContentController.new,
      name: r'textContentControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$textContentControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TextContentController = AutoDisposeNotifier<TextContent?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
