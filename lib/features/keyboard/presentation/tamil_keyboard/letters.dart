import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
class Letters {
  static List<String> uyirLetters = [
    'அ',
    'ஆ',
    'இ',
    'ஈ',
    'உ',
    'ஊ',
    'எ',
    'ஏ',
    'ஒ',
    'ஓ',
    'ஐ',
    'ஔ',
  ];

  static List<String> meiLetters = [
    'ம', 'ச', 'ற', 'ய', 'வ', 'ண', 'க', 'ந', 'ர', 'ங', 'ப', 'ல', 'ன',
    'த', 'ட', 'ஞ', 'ழ', 'ள',
    'ஜ',
    'ஷ',
    'ஸ',
    'ஹ', // Added special consonants so they can accept diacritics
  ];

  static List<String> leftDiacriticLetters = ['ெ', 'ே', 'ை'];

  static List<String> rightDiacriticLetters = ['ி', 'ீ', 'ு', 'ூ', '்', 'ா'];

  /// Bases that form ௌ from ெ + [ள] shortcut (longest multi-grapheme first for [endsWith]).
  static List<String> get auBasesLongestFirst {
    return ['க்ஷ', ...meiLetters];
  }

  /// When the field already ends with one of these, the [ள] key stays [ள] (no AU shortcut).
  /// Note: [ளெ] is omitted so [ளெ]+[ள] can still form [ளௌ].
  static const List<String> laContextSuffixesLongestFirst = [
    'ஒள',
    'ளோ',
    'ளை',
    'ளீ',
    'ளா',
    'ளி',
    'ளு',
    'ளூ',
    'ள்',
    'ள',
  ];

  static List<String> specialKeys = [
    'ஃ', 'க்ஷ', 'ஸ்ரீ', // Keep only truly special multi-character keys here
  ];

  static List<String> symbols = [
    '@',
    '#',
    '₹',
    '_',
    '&',
    '-',
    '+',
    '(',
    ')',
    '/',
    '*',
    '"',
    "'",
    ':',
    ';',
    '!',
    '?',
    '~',
    '^',
    '|',
    '•',
    '√',
    'π',
    '±',
    '+',
    '×',
    '§',
    '\$',
    '௹',
    '£',
    '€',
    '¥',
    '°',
    '=',
    '{',
    '}',
    '\\',
    '%',
    '©',
    '®',
    '™',
    '✓',
    '[',
    ']',
  ];

  static Map<String, String> diacriticCombos = {
    'ொ': 'ொ', // short O
    'ோ': 'ோ', // long O
    'ௌ': 'ௌ', // AU
  };

  /// Decomposed keyboard pairs → precomposed (must match practice/challenge editors).
  /// Use before NFC so progress length matches [String] code-unit indices.
  static String applyDiacriticCompositions(String text) {
    var result = text;
    for (final entry in diacriticCombos.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Tamil typing normalization: compositions then NFC (editors, session, keyboard).
  static String normalizeTypingText(String text) {
    return unorm.nfc(applyDiacriticCompositions(text));
  }

  /// True when typed line matches target (exact or same visual grapheme sequence).
  static bool typingTextsEquivalent(String typed, String target) {
    final a = normalizeTypingText(typed);
    final b = normalizeTypingText(target);
    if (a == b) return true;
    return a.characters.join() == b.characters.join();
  }

  /// Visual typing length: grapheme clusters after Tamil normalize (matches UI).
  static int typingGraphemeCount(String text) {
    if (text.isEmpty) return 0;
    return normalizeTypingText(text).characters.length;
  }
}
