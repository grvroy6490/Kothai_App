

class Letters {
    static List<String> uyirLetters = [
        'அ', 'ஆ', 'இ', 'ஈ', 'உ', 'ஊ', 'எ', 'ஏ', 'ஒ', 'ஓ', 'ஐ', 'ஔ',
    ];

    static List<String> meiLetters = [
        'ம', 'ச', 'ற', 'ய', 'வ', 'ண', 'க', 'ந', 'ர', 'ங', 'ப', 'ல', 'ன',
        'த', 'ட', 'ஞ', 'ழ', 'ள',
        'ஜ', 'ஷ', 'ஸ', 'ஹ', // Added special consonants so they can accept diacritics
    ];

    static List<String> leftDiacriticLetters = [
        'ெ', 'ே', 'ை'
    ];

    static List<String> rightDiacriticLetters = [
        'ி', 'ீ', 'ு', 'ூ', '்', 'ா', 'ௗ'
    ];

    static List<String> specialKeys = [
        'ஃ', 'க்ஷ', 'ஸ்ரீ', // Keep only truly special multi-character keys here
    ];

    static List<String> symbols = [
      '@', '#', '₹', '_', '&', '-', '+', '(', ')', '/', '*', '"', "'", ':',
      ';', '!', '?', '~', '^', '|', '•', '√', 'π', '±', '+', '×', '§', '\$',
      '௹', '£', '€', '¥', '°', '=', '{', '}', '\\', '%', '©', '®', '™', '✓', '[', ']'
    ];

    static Map<String, String> diacriticCombos = {
        'ொ': 'ொ',  // short O
        'ோ': 'ோ', // long O
        'ௌ': 'ௌ', // AU
    };



}