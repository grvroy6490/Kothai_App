


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_preloader_provider.g.dart';

@riverpod
Future<void> preloadOnConfigController(Ref ref) async {
    final config = ref.watch(practiceConfigurationProvider);
    await ref.watch(preloadTypingTextsProvider).call(
        difficulty: config.difficulty,
        randomize: config.randomize
    );
}