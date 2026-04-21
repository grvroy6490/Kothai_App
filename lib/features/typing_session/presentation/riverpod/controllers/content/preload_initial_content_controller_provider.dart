


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/content/text_content_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preload_initial_content_controller_provider.g.dart';

@riverpod
Future<void> preloadPracticeInitialContentController(Ref ref) async {
    await ref.read(practiceContentRepositoryProvider).preloadInitialTexts();
}



@riverpod
Future<void> preloadChallengeInitialContentController(Ref ref) async {
  await ref.read(challengeContentRepositoryProvider).preloadInitialTexts();
}