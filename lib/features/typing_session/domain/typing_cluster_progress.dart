import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';

/// Progress / completion using the same cluster walk as [AnimatedContentBoard].
/// Counting graphemes in the field alone is wrong (e.g. ம vs ஂ both count as 1).
class TypingClusterProgress {
  const TypingClusterProgress({
    required this.completedTargetClusters,
    required this.totalTargetClusters,
    required this.progress,
    required this.isComplete,
    required this.waitingForMoreInput,
  });

  final int completedTargetClusters;
  final int totalTargetClusters;
  final double progress;
  final bool isComplete;
  final bool waitingForMoreInput;

  static TypingClusterProgress assess(String typed, String target) {
    if (target.isEmpty) {
      return const TypingClusterProgress(
        completedTargetClusters: 0,
        totalTargetClusters: 0,
        progress: 0,
        isComplete: false,
        waitingForMoreInput: false,
      );
    }

    final normalizedPara = Letters.normalizeTypingText(target);
    final normalizedInput = Letters.normalizeTypingText(typed);

    if (normalizedInput == normalizedPara ||
        normalizedInput.characters.join() ==
            normalizedPara.characters.join()) {
      final total = normalizedPara.characters.length;
      return TypingClusterProgress(
        completedTargetClusters: total,
        totalTargetClusters: total,
        progress: 1,
        isComplete: true,
        waitingForMoreInput: false,
      );
    }

    final paraClusters = normalizedPara.characters.toList();
    final inputClusters = normalizedInput.characters.toList();
    final total = paraClusters.length;
    if (total == 0) {
      return const TypingClusterProgress(
        completedTargetClusters: 0,
        totalTargetClusters: 0,
        progress: 0,
        isComplete: false,
        waitingForMoreInput: false,
      );
    }

    var inputIndex = 0;
    final currentInputLength = inputClusters.length;
    var isInWaitingState = false;
    var completedTargetClusters = 0;
    var waitingForMoreInput = false;
    var reachedEndOfTarget = false;

    for (var i = 0; i < paraClusters.length; i++) {
      final paraChar = paraClusters[i];

      String? typed = (!isInWaitingState && inputIndex < inputClusters.length)
          ? inputClusters[inputIndex]
          : null;

      // No input for this target cluster yet (e.g. மாறு typed but ஂ not).
      if (typed == null) {
        break;
      }

      var isWaitingForSecondChar = false;

      if (_isSpecialMultiCharSequence(paraChar)) {
        if (typed != paraChar && _isPartialSpecialSequence(paraChar, typed)) {
          if (inputIndex == currentInputLength - 1) {
            isWaitingForSecondChar = true;
            isInWaitingState = true;
          }
        }
      } else if (_isKshaWithDiacritic(paraChar) &&
          unorm.nfc(typed) == unorm.nfc('க்ஷ')) {
        if (inputIndex == currentInputLength - 1) {
          isWaitingForSecondChar = true;
          isInWaitingState = true;
        }
      } else if (_isTwoCharDiacriticCombination(paraChar)) {
        if (typed != paraChar) {
          final paraRunes = paraChar.runes.toList();
          if (paraRunes.length == 2) {
            final expectedMei = String.fromCharCode(paraRunes[0]);
            final typedRunes = typed.runes.toList();
            if (typedRunes.length == 1) {
              final typedChar = String.fromCharCode(typedRunes[0]);
              if (typedChar == expectedMei &&
                  Letters.meiLetters.contains(typedChar) &&
                  inputIndex == currentInputLength - 1) {
                isWaitingForSecondChar = true;
                isInWaitingState = true;
              }
            }
          }
        }
      } else if (_isPartialGraphemeCluster(paraChar, typed) &&
          inputIndex == currentInputLength - 1) {
        isWaitingForSecondChar = true;
        isInWaitingState = true;
      } else if (_isLeftDiacriticWaitingForCombo(paraChar, typed) &&
          inputIndex == currentInputLength - 1) {
        isWaitingForSecondChar = true;
        isInWaitingState = true;
      } else if (_isCombinedLetterForm(paraChar) &&
          typed != paraChar &&
          _isPartialGraphemeCluster(paraChar, typed) &&
          inputIndex == currentInputLength - 1) {
        isWaitingForSecondChar = true;
        isInWaitingState = true;
      }

      if (isWaitingForSecondChar) {
        waitingForMoreInput = true;
        break;
      }

      inputIndex++;
      isInWaitingState = false;
      completedTargetClusters = i + 1;
      if (i == paraClusters.length - 1) {
        reachedEndOfTarget = true;
      }
    }

    final progress = (completedTargetClusters / total).clamp(0.0, 1.0);
    final isComplete = reachedEndOfTarget && !waitingForMoreInput;

    return TypingClusterProgress(
      completedTargetClusters: completedTargetClusters,
      totalTargetClusters: total,
      progress: progress,
      isComplete: isComplete,
      waitingForMoreInput: waitingForMoreInput,
    );
  }

  static bool _isCombinedLetterForm(String cluster) {
    final normalizedCluster = unorm.nfc(cluster);
    var hasMei = false;
    for (final mei in Letters.meiLetters) {
      if (normalizedCluster.contains(mei)) {
        hasMei = true;
        break;
      }
    }
    var hasSpecialDiacriticCombo = false;
    for (final combo in Letters.diacriticCombos.values) {
      final normalizedCombo = unorm.nfc(combo);
      if (normalizedCluster.contains(normalizedCombo)) {
        hasSpecialDiacriticCombo = true;
        break;
      }
    }
    if (hasMei && hasSpecialDiacriticCombo) return true;

    final runes = normalizedCluster.runes.toList();
    if (runes.length < 3) return false;

    var hasLeftDiacritic = false;
    var hasRightDiacritic = false;
    for (final left in Letters.leftDiacriticLetters) {
      if (normalizedCluster.contains(left)) {
        hasLeftDiacritic = true;
        break;
      }
    }
    for (final right in Letters.rightDiacriticLetters) {
      if (normalizedCluster.contains(right)) {
        hasRightDiacritic = true;
        break;
      }
    }
    return hasMei && hasLeftDiacritic && hasRightDiacritic;
  }

  static bool _isSpecialMultiCharSequence(String cluster) {
    return Letters.specialKeys.contains(unorm.nfc(cluster));
  }

  static bool _isPartialSpecialSequence(String expected, String typed) {
    final normalizedExpected = unorm.nfc(expected);
    final normalizedTyped = unorm.nfc(typed);
    return normalizedExpected.startsWith(normalizedTyped) &&
        normalizedTyped.length < normalizedExpected.length;
  }

  static bool _isKshaWithDiacritic(String cluster) {
    final n = unorm.nfc(cluster);
    const ksha = 'க்ஷ';
    return n != ksha && n.startsWith(ksha) && n.length > ksha.length;
  }

  static bool _isLeftDiacriticWaitingForCombo(String expected, String typed) {
    final er = unorm.nfc(expected).runes.toList();
    final tr = unorm.nfc(typed).runes.toList();
    if (er.length != tr.length || er.length < 2) return false;
    const int leftShort = 0x0BC6;
    const int leftLong = 0x0BC7;
    const int leftAi = 0x0BC8;
    const int comboShortO = 0x0BCA;
    const int comboLongO = 0x0BCB;
    const int comboAu = 0x0BCC;
    final expectedLast = er.last;
    final typedLast = tr.last;
    final expectedCombo = expectedLast == comboShortO ||
        expectedLast == comboLongO ||
        expectedLast == comboAu;
    final typedLeft = typedLast == leftShort ||
        typedLast == leftLong ||
        typedLast == leftAi;
    if (!expectedCombo || !typedLeft) return false;
    for (var i = 0; i < er.length - 1; i++) {
      if (er[i] != tr[i]) return false;
    }
    return true;
  }

  static bool _isPartialGraphemeCluster(String expected, String typed) {
    final expectedRunes = unorm.nfc(expected).runes.toList();
    final typedRunes = unorm.nfc(typed).runes.toList();
    if (typedRunes.isEmpty || typedRunes.length >= expectedRunes.length) {
      return false;
    }
    for (var i = 0; i < typedRunes.length; i++) {
      if (typedRunes[i] != expectedRunes[i]) return false;
    }
    return true;
  }

  static bool _isTwoCharDiacriticCombination(String cluster) {
    final normalizedCluster = unorm.nfc(cluster);
    final runes = normalizedCluster.runes.toList();
    if (runes.length != 2) return false;
    final firstChar = String.fromCharCode(runes[0]);
    final secondChar = String.fromCharCode(runes[1]);
    const composedVowelMarks = {'\u0BCA', '\u0BCB', '\u0BCC'}; // ொ, ோ, ௌ
    return Letters.meiLetters.contains(firstChar) &&
        (Letters.rightDiacriticLetters.contains(secondChar) ||
            composedVowelMarks.contains(secondChar));
  }
}
