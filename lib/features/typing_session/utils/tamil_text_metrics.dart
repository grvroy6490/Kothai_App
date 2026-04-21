class TamilTextMetrics {
  static const int charsPerWord = 7;

  static int countGraphemeClusters(String text) {
    if (text.isEmpty) return 0;

    final runes = text.runes.toList();
    var count = 0;
    var i = 0;

    while (i < runes.length) {
      count++;
      i++;
      while (i < runes.length && _isCombiningMark(runes[i])) {
        i++;
      }
    }

    return count;
  }

  static List<String> splitClusters(String text) {
    final clusters = <String>[];
    final runes = text.runes.toList();
    var i = 0;

    while (i < runes.length) {
      final buffer = StringBuffer();
      buffer.writeCharCode(runes[i]);
      i++;

      while (i < runes.length && _isCombiningMark(runes[i])) {
        buffer.writeCharCode(runes[i]);
        i++;
      }

      clusters.add(buffer.toString());
    }

    return clusters;
  }

  static bool _isCombiningMark(int codePoint) {
    return (codePoint >= 0x0BBE && codePoint <= 0x0BCD) ||
        codePoint == 0x0BD7;
  }
}
