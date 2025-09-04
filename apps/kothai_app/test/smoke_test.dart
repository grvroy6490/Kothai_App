import 'package:flutter_test/flutter_test.dart';
import 'package:kothai_domain/kothai_domain.dart';

void main() {
  test('domain import works', () {
    const pack = LanguagePack(languageCode: 'ta', version: '1');
    expect(pack.languageCode, 'ta');
  });
}
