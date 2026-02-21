import 'package:visai/domain/repositories/content/text_repository.dart';

class PreloadTypingTexts {
    final TextRepository repo;
    PreloadTypingTexts(this.repo);

    Future<void> call() async => await repo.preloadInitialTexts();
}
