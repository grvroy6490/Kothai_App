import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:visai/features/keyboard/presentation/providers/keyboard_provider.dart';
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

class TamilKeyboard extends KeyboardController {
  /// Tamil AU length mark (U+0BD7). Not on the key row; only used internally so
  /// [ள] can trigger ெ→ௌ composition without a visible [ௗ] key.
  static const String _auComposeSentinel = '\u0BD7';

  String? _heldLeftDiacritic;
  Ref? _ref;

  TamilKeyboard(super.text);

  void setRef(Ref ref) {
    _ref = ref;
  }

  @override
  void resetCompositionState() {
    _heldLeftDiacritic = null;
    _ref?.read(holdKeyProvider.notifier).clear();
  }

  @override
  void backspace(String value) {
    // Backspace should also honor the initial diacritic rule only if text is empty
    // If empty, nothing to delete; just return
    if (text.text.isEmpty) {
      return;
    }
    final selection = text.selection;
    final textValue = text.text;

    // If there's a selection, delete the selected text
    if (selection.start != selection.end) {
      // Clamp start and end to valid range [0, textValue.length]
      final start = selection.start.clamp(0, textValue.length);
      final end = selection.end.clamp(0, textValue.length);
      final newText = textValue.replaceRange(start, end, '');
      text.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start),
      );
      return;
    }

    // If selection is collapsed, delete the character before the caret
    final caretIndex = selection.start.clamp(0, textValue.length);
    if (caretIndex <= 0) return;

    final newText = textValue.replaceRange(caretIndex - 1, caretIndex, '');
    text.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: caretIndex - 1),
    );
    // _ref?.read(sessionStateProvider.notifier).backspace();
  }

  @override
  void insert(String value) {
    // Handle left diacritic hold mechanism.
    // The hold waits for the NEXT consonant typed (not the previous char), so we
    // must not block it based on what precedes in the text field.
    if (Letters.leftDiacriticLetters.contains(value)) {
      _heldLeftDiacritic = value;
      _ref?.read(holdKeyProvider.notifier).holdFor(value);
      return;
    }

    // Check haptic based on session mode
    if (_ref != null) {
      final sessionStatus = _ref!.read(sessionStatusControllerProvider);
      final sessionMode = sessionStatus.mode;

      final hapticEnabled = sessionMode == SessionMode.challenge
          ? _ref!.read(challengeConfigurationProvider).hapticEnabled
          : _ref!.read(practiceConfigurationProvider).hapticEnabled;

      if (hapticEnabled) {
        _vibrate();
      }
    }

    if (value == ' ' || value == '\n') {
      if (_heldLeftDiacritic != null) {
        _heldLeftDiacritic = null;
        _ref?.read(holdKeyProvider.notifier).clear();
      }
      _insertText(value);
      for (var ch in value.characters) {
        _notifyOnKey(ch);
      }
      return;
    }

    if (value == 'delete') {
      if (_heldLeftDiacritic != null) {
        _heldLeftDiacritic = null;
        _ref?.read(holdKeyProvider.notifier).clear();
      }
      return;
    }

    // Handle held left diacritic
    if (_heldLeftDiacritic != null) {
      // Check if value is a mei letter, special consonant, or க்ஷ (for க்ஷெ, க்ஷே, க்ஷை)
      final canTakeLeftDiacritic = Letters.meiLetters.contains(value) ||
          ['ஜ', 'ஷ', 'ஸ', 'ஹ'].contains(value) ||
          value == 'க்ஷ';
      if (canTakeLeftDiacritic) {
        final combinedValue = value + _heldLeftDiacritic!;
        _heldLeftDiacritic = null;
        _ref?.read(holdKeyProvider.notifier).clear();
        _insertText(_normalizeAndInsert(combinedValue));
        for (var ch in combinedValue.characters) {
          _notifyOnKey(ch);
        }
        return;
      } else {
        _heldLeftDiacritic = null;
        _ref?.read(holdKeyProvider.notifier).clear();
        _insertText(value);
        for (var ch in value.characters) {
          _notifyOnKey(ch);
        }
        return;
      }
    }

    final int cursor = text.selection.baseOffset.clamp(0, text.text.length);
    final String prefixStr = text.text.substring(0, cursor);
    final String suffixStr = text.text.substring(cursor);

    // [ள] completes AU (ெ → ௌ) on mei / க்ஷ; stays [ள] after ள-conjugates (ள்…ஒள).
    if (value == 'ள' &&
        !_prefixEndsWithLaContext(prefixStr) &&
        _prefixEndsWithMeiPlusShortE(prefixStr)) {
      final composed = _composeMeiEWithAalOrDot(prefixStr, _auComposeSentinel);
      if (composed != null) {
        final normalized = _normalizeAndInsert(composed + suffixStr);
        text.value = TextEditingValue(
          text: normalized,
          selection: TextSelection.collapsed(offset: composed.length),
        );
        for (var ch in 'ௌ'.characters) {
          _notifyOnKey(ch);
        }
        return;
      }
    }

    if (Letters.rightDiacriticLetters.contains(value)) {
      if (prefixStr.isEmpty) return;

      // ெ+ா→ொ, ே+ா→ோ with full consonant cluster (க்ஷெ, கெ, …).
      if (value == 'ா') {
        final composed = _composeMeiEWithAalOrDot(prefixStr, value);
        if (composed != null) {
          final normalized = _normalizeAndInsert(composed + suffixStr);
          text.value = TextEditingValue(
            text: normalized,
            selection: TextSelection.collapsed(offset: composed.length),
          );
          for (var ch in value.characters) {
            _notifyOnKey(ch);
          }
          return;
        }
      }

      final lastChar = prefixStr.characters.last;
      if (Letters.uyirLetters.contains(lastChar) && lastChar != 'ஒ') return;

      final multiCharSequences = ['க்ஷ', 'ஸ்ரீ'];
      String? matchingSequence;
      for (final seq in multiCharSequences) {
        if (prefixStr.endsWith(seq)) {
          matchingSequence = seq;
          break;
        }
      }

      if (!Letters.uyirLetters.contains(lastChar) || matchingSequence != null) {
        final base = matchingSequence ?? lastChar;
        final combinedValue = base + value;
        final before = prefixStr.substring(0, prefixStr.length - base.length);
        final newText = _normalizeAndInsert(before + combinedValue + suffixStr);

        text.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: before.length + combinedValue.length),
        );

        for (var ch in combinedValue.characters) {
          _notifyOnKey(ch);
        }
        return;
      }
    }

    // NFC-style pairs (e.g. bare ெ+ா) when not handled above.
    if (prefixStr.isNotEmpty) {
      final lastCluster = prefixStr.characters.last;
      final comboKey = lastCluster + value;
      if (Letters.diacriticCombos.containsKey(comboKey)) {
        final combined = Letters.diacriticCombos[comboKey]!;
        final newPrefix = prefixStr.characters.skipLast(1).string + combined;
        final normalized = _normalizeAndInsert(newPrefix + suffixStr);

        text.value = TextEditingValue(
          text: normalized,
          selection: TextSelection.collapsed(offset: newPrefix.length),
        );
        return;
      }
    }

    final newPrefix = prefixStr + value;
    final normalized = _normalizeAndInsert(newPrefix + suffixStr);

    text.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: newPrefix.length),
    );

    for (var ch in value.characters) {
      _notifyOnKey(ch);
    }
  }

  /// True when [prefix] ends with `…<mei>ெ` and `<mei>` is in [Letters.auBasesLongestFirst].
  bool _prefixEndsWithMeiPlusShortE(String prefix) {
    if (!prefix.endsWith('ெ')) return false;
    final withoutE = prefix.substring(0, prefix.length - 'ெ'.length);
    for (final base in Letters.auBasesLongestFirst) {
      if (withoutE.endsWith(base)) return true;
    }
    return false;
  }

  bool _prefixEndsWithLaContext(String prefix) {
    for (final s in Letters.laContextSuffixesLongestFirst) {
      if (prefix.endsWith(s)) return true;
    }
    return false;
  }

  /// ெ+ா→ொ, ே+ா→ோ, or ெ+[_auComposeSentinel]→ௌ while keeping the consonant cluster.
  String? _composeMeiEWithAalOrDot(String prefix, String value) {
    if (value != 'ா' && value != _auComposeSentinel) return null;
    const e = 'ெ';
    const ee = 'ே';
    const o = 'ொ';
    const oo = 'ோ';
    const au = 'ௌ';
    for (final base in Letters.auBasesLongestFirst) {
      if (value == 'ா') {
        if (prefix.endsWith(base + e)) {
          return prefix.substring(0, prefix.length - (base + e).length) + base + o;
        }
        if (prefix.endsWith(base + ee)) {
          return prefix.substring(0, prefix.length - (base + ee).length) + base + oo;
        }
      } else if (value == _auComposeSentinel && prefix.endsWith(base + e)) {
        return prefix.substring(0, prefix.length - (base + e).length) + base + au;
      }
    }
    return null;
  }

  void _insertText(String value) {
    final selection = text.selection;
    final textValue = text.text;
    // Clamp start and end to valid range [0, textValue.length]
    // start can be equal to length for insertion at the end
    final start = selection.start.clamp(0, textValue.length);
    final end = selection.end.clamp(0, textValue.length);
    final newText = textValue.replaceRange(start, end, value);

    final newOffset = start + value.length;
    text.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  void _vibrate() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
  }

  void _notifyOnKey(String ch) {
    // TODO: Check this settings
    final para = _ref?.read(textContentControllerProvider)?.content ?? '';
    final idx = text.text.length - 1;
    final expected = (idx >= 0 && idx < para.length) ? para[idx] : null;
    final correct = expected != null && ch == expected;

    // _ref?.read(sessionControllerProvider.notifier).onKey(correct: correct);
  }

  String _normalizeAndInsert(String text) {
    return Letters.normalizeTypingText(text);
  }
}
