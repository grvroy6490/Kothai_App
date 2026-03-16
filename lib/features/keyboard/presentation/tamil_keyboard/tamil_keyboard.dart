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
  String? _heldLeftDiacritic;
  Ref? _ref;

  TamilKeyboard(super.text);

  void setRef(Ref ref) {
    _ref = ref;
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
    // Handle left diacritic hold mechanism
    if (Letters.leftDiacriticLetters.contains(value)) {
      if (text.text.isNotEmpty) {
        final lastChar = text.text.characters.last;
        if (Letters.uyirLetters.contains(lastChar) && lastChar != 'ஒ') {
          return; // Don't hold diacritic after uyir
        }
      }
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

    if (Letters.rightDiacriticLetters.contains(value)) {
      if (text.text.isEmpty) return;
      final lastChar = text.text.characters.last;
      if (Letters.uyirLetters.contains(lastChar) && lastChar != 'ஒ') return;

      // Check for multi-character sequences first (like 'க்ஷ', 'ஸ்ரீ')
      final multiCharSequences = ['க்ஷ', 'ஸ்ரீ'];
      String? matchingSequence;
      for (final seq in multiCharSequences) {
        if (text.text.endsWith(seq)) {
          matchingSequence = seq;
          break;
        }
      }

      // Allow right diacritics on mei letters AND special consonants
      if (!Letters.uyirLetters.contains(lastChar) || matchingSequence != null) {
        final base = matchingSequence ?? lastChar;
        final combinedValue = base + value;
        final prefix = text.text.substring(0, text.text.length - base.length);
        final newText = _normalizeAndInsert(prefix + combinedValue);

        text.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );

        for (var ch in combinedValue.characters) {
          _notifyOnKey(ch);
        }
        return;
      }
    }

    // Handle special diacritic combos (like ெ + ா = ொ)
    final cursorPosition = text.selection.baseOffset;
    final prefix = text.text.characters.take(cursorPosition).string;
    final suffix = text.text.characters.skip(cursorPosition).string;

    if (prefix.isNotEmpty) {
      final lastCluster = prefix.characters.last;
      final comboKey = lastCluster + value;
      if (Letters.diacriticCombos.containsKey(comboKey)) {
        final combined = Letters.diacriticCombos[comboKey]!;
        final newPrefix = prefix.characters.skipLast(1).string + combined;
        final normalized = _normalizeAndInsert(newPrefix + suffix);

        text.value = TextEditingValue(
          text: normalized,
          selection: TextSelection.collapsed(offset: newPrefix.length),
        );
        return;
      }
      // Multi-char base: cluster ending with ெ/ே/ை + ா/ௗ → ொ/ோ/ௌ (e.g. க்ஷெ + ா → க்ஷொ)
      if (Letters.rightDiacriticLetters.contains(value) &&
          (value == 'ா' || value == 'ௗ') &&
          lastCluster.runes.isNotEmpty) {
        const int leftShort = 0x0BC6; // ெ
        const int leftLong = 0x0BC7;  // ே
        const int comboShortO = 0x0BCA; // ொ
        const int comboLongO = 0x0BCB;  // ோ
        const int comboAu = 0x0BCC;    // ௌ
        final runes = lastCluster.runes.toList();
        final lastRune = runes.last;
        int? replacement;
        if (value == 'ா') {
          if (lastRune == leftShort) replacement = comboShortO;
          if (lastRune == leftLong) replacement = comboLongO;
        } else if (value == 'ௗ') {
          if (lastRune == leftShort) replacement = comboAu;
        }
        if (replacement != null) {
          final newRunes = runes.sublist(0, runes.length - 1)..add(replacement);
          final newLastCluster = String.fromCharCodes(newRunes);
          final newPrefix = prefix.characters.skipLast(1).string + newLastCluster;
          final normalized = _normalizeAndInsert(newPrefix + suffix);
          text.value = TextEditingValue(
            text: normalized,
            selection: TextSelection.collapsed(offset: newPrefix.length),
          );
          return;
        }
      }
    }

    // Default insert
    final newPrefix = prefix + value;
    final normalized = _normalizeAndInsert(newPrefix + suffix);

    text.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: newPrefix.length),
    );

    for (var ch in value.characters) {
      _notifyOnKey(ch);
    }
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
    return unorm.nfc(text);
  }
}
