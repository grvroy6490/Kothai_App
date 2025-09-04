library kothai_data;

import 'package:kothai_domain/kothai_domain.dart';

abstract class LanguagePackRepository {
  Future<LanguagePack?> fetchLatest(String languageCode);
}
