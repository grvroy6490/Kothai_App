import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:visai/features/typing_session/domain/entities/session/session_handler_entity.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:logger/logger.dart';
import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:vibration/vibration.dart';

class AnimatedContentBoard extends ConsumerStatefulWidget {
  final String paragraph;
  AnimatedContentBoard({super.key, required this.paragraph});

  @override
  ConsumerState<AnimatedContentBoard> createState() =>
      _AnimatedContentBoardState();
}

class _AnimatedContentBoardState extends ConsumerState<AnimatedContentBoard> {
  @override
  Widget build(BuildContext context) {
    // 🌐 PROVIDERS ------------------------------
    final sessionStatus = ref.watch(sessionStatusControllerProvider);
    final userInput = ref.watch(userInputProvider);

    // 📃 DECLARATION ----------------------------
    final isPracticeStart = sessionStatus.status == SessionStatusEnum.start;

    // ⭐ Widget ---------------------------------
    return AnimatedSize(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        height: isPracticeStart
            ? MediaQuery.of(context).size.height * 0.35
            : MediaQuery.of(
                context,
              ).size.height, // 👈 Update height animation here
        // decoration: BoxDecoration(color: Colors.white24),
        child: TypingArea(
          paragraph: widget.paragraph,
          userInput: userInput,
        ), // Typing Area
      ),
    );
  }
}

class TypingArea extends ConsumerStatefulWidget {
  final String paragraph;
  final String userInput;
  TypingArea({super.key, required this.paragraph, required this.userInput});

  @override
  ConsumerState<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends ConsumerState<TypingArea>
    with SingleTickerProviderStateMixin {
  final logger = Logger();
  String? _previousInput;
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;

  @override
  void initState() {
    super.initState();
    _previousInput = null;
    // Initialize cursor blinking animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
    _cursorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  /// Checks if a character cluster is a combined letter form
  /// Combined forms are: mei + special diacritic combo (like கொ, கோ, கௌ)
  /// Or mei + left diacritic + right diacritic (3-character combination)
  bool _isCombinedLetterForm(String cluster) {
    // Normalize the cluster to ensure consistent comparison
    final normalizedCluster = unorm.nfc(cluster);

    // Check if cluster contains a special diacritic combo character (ொ, ோ, ௌ)
    // along with a mei letter (like கொ, கோ, கௌ)
    bool hasMei = false;
    bool hasSpecialDiacriticCombo = false;

    // Check if cluster contains any mei letter
    for (final mei in Letters.meiLetters) {
      if (normalizedCluster.contains(mei)) {
        hasMei = true;
        break;
      }
    }

    // Check if cluster contains any special diacritic combo character
    // Normalize each combo to ensure proper matching
    for (final combo in Letters.diacriticCombos.values) {
      final normalizedCombo = unorm.nfc(combo);
      // Check if the normalized cluster contains the normalized combo
      if (normalizedCluster.contains(normalizedCombo)) {
        hasSpecialDiacriticCombo = true;
        break;
      }
      // Also check if any rune in the cluster matches the combo
      final clusterRunes = normalizedCluster.runes.toSet();
      final comboRunes = normalizedCombo.runes.toSet();
      if (clusterRunes.intersection(comboRunes).isNotEmpty) {
        hasSpecialDiacriticCombo = true;
        break;
      }
    }

    // If it has mei + special diacritic combo, it's a combined form
    if (hasMei && hasSpecialDiacriticCombo) {
      return true;
    }

    // Check if the cluster contains mei + left diacritic + right diacritic
    // This is a 3-character combination
    final runes = normalizedCluster.runes.toList();
    if (runes.length < 3) {
      return false; // Simple characters have 1-2 code points
    }

    // Check the string directly for presence of components
    bool hasLeftDiacritic = false;
    bool hasRightDiacritic = false;

    // Check if cluster contains any left diacritic
    for (final leftDiacritic in Letters.leftDiacriticLetters) {
      if (normalizedCluster.contains(leftDiacritic)) {
        hasLeftDiacritic = true;
        break;
      }
    }

    // Check if cluster contains any right diacritic
    for (final rightDiacritic in Letters.rightDiacriticLetters) {
      if (normalizedCluster.contains(rightDiacritic)) {
        hasRightDiacritic = true;
        break;
      }
    }

    // Combined form requires all three: mei + left diacritic + right diacritic
    return hasMei && hasLeftDiacritic && hasRightDiacritic;
  }

  /// Checks if a character is a space
  bool _isSpace(String char) {
    return char.trim().isEmpty && char.isNotEmpty;
  }

  /// Checks if a character cluster is a special multi-character sequence
  /// Examples: "க்ஷ", "ஸ்ரீ"
  bool _isSpecialMultiCharSequence(String cluster) {
    final normalizedCluster = unorm.nfc(cluster);
    return Letters.specialKeys.contains(normalizedCluster);
  }

  /// Checks if typed is a partial match of the expected special sequence
  /// Returns true if typed is a prefix of the expected sequence
  bool _isPartialSpecialSequence(String expected, String typed) {
    final normalizedExpected = unorm.nfc(expected);
    final normalizedTyped = unorm.nfc(typed);

    // Check if typed is a prefix of expected
    if (normalizedExpected.startsWith(normalizedTyped) &&
        normalizedTyped.length < normalizedExpected.length) {
      return true;
    }
    return false;
  }

  /// True when cluster is க்ஷ with a vowel/diacritic (e.g. க்ஷா, க்ஷெ, க்ஷொ)
  bool _isKshaWithDiacritic(String cluster) {
    final n = unorm.nfc(cluster);
    const ksha = 'க்ஷ';
    return n != ksha && n.startsWith(ksha) && n.length > ksha.length;
  }

  /// True when expected ends with ொ/ோ/ௌ and typed ends with ெ/ே/ை on same base
  /// (e.g. typed ஹெ, expected ஹொ — user will type ா next to get ொ).
  bool _isLeftDiacriticWaitingForCombo(String expected, String typed) {
    final er = unorm.nfc(expected).runes.toList();
    final tr = unorm.nfc(typed).runes.toList();
    if (er.length != tr.length || er.length < 2) return false;
    const int leftShort = 0x0BC6; // ெ
    const int leftLong = 0x0BC7;  // ே
    const int leftAi = 0x0BC8;    // ை
    const int comboShortO = 0x0BCA; // ொ
    const int comboLongO = 0x0BCB;  // ோ
    const int comboAu = 0x0BCC;    // ௌ
    final expectedLast = er.last;
    final typedLast = tr.last;
    final expectedCombo = expectedLast == comboShortO || expectedLast == comboLongO || expectedLast == comboAu;
    final typedLeft = typedLast == leftShort || typedLast == leftLong || typedLast == leftAi;
    if (!expectedCombo || !typedLeft) return false;
    for (var i = 0; i < er.length - 1; i++) {
      if (er[i] != tr[i]) return false;
    }
    return true;
  }

  /// Generic helper: true when `typed` is a proper prefix of `expected`
  /// at the rune level (used for multi-step clusters like கள்).
  bool _isPartialGraphemeCluster(String expected, String typed) {
    final expectedRunes = unorm.nfc(expected).runes.toList();
    final typedRunes = unorm.nfc(typed).runes.toList();
    if (typedRunes.isEmpty || typedRunes.length >= expectedRunes.length) {
      return false;
    }
    for (var i = 0; i < typedRunes.length; i++) {
      if (typedRunes[i] != expectedRunes[i]) {
        return false;
      }
    }
    return true;
  }

  /// Checks if a character cluster is a 2-character combination (mei + right diacritic)
  /// Examples: "யா", "ளை", "லி"
  bool _isTwoCharDiacriticCombination(String cluster) {
    final normalizedCluster = unorm.nfc(cluster);
    final runes = normalizedCluster.runes.toList();

    // Must have exactly 2 runes (mei + right diacritic)
    if (runes.length != 2) {
      return false;
    }

    // Check if first character is a mei letter
    final firstChar = String.fromCharCode(runes[0]);
    final hasMei = Letters.meiLetters.contains(firstChar);

    // Check if second character is a right diacritic
    final secondChar = String.fromCharCode(runes[1]);
    final hasRightDiacritic = Letters.rightDiacriticLetters.contains(
      secondChar,
    );

    return hasMei && hasRightDiacritic;
  }

  @override
  Widget build(BuildContext context) {
    // 🌐 PROVIDERS ------------------------------
    final practiceConfig = ref.watch(practiceConfigurationProvider);
    final sessionStatus = ref.watch(sessionStatusControllerProvider);
    final normalizedPara = unorm.nfc(widget.paragraph);
    final normalizedInput = unorm.nfc(widget.userInput);

    // 🚀 METHODS --------------------------------
    // Handle haptic / vibration based on practice config
    // Detect errors at character level by comparing input with paragraph
    if (practiceConfig.hapticOnError) {
      if (_previousInput != null) {
        final paraClusters = normalizedPara.characters.toList();
        final inputClusters = normalizedInput.characters.toList();
        final previousInputClusters = _previousInput!.characters.toList();

        // Check if input length increased (new character typed)
        if (inputClusters.length > previousInputClusters.length) {
          final newInputIndex = inputClusters.length - 1;

          // Check if the newly typed character is incorrect
          if (newInputIndex < paraClusters.length) {
            final expectedChar = paraClusters[newInputIndex];
            final typedChar = inputClusters[newInputIndex];

            // Only treat as error when fully wrong — not when waiting for second char
            final bool isPartialInput = typedChar != expectedChar &&
                (_isPartialSpecialSequence(expectedChar, typedChar) ||
                    (_isKshaWithDiacritic(expectedChar) &&
                        unorm.nfc(typedChar) == unorm.nfc('க்ஷ')) ||
                    (_isTwoCharDiacriticCombination(expectedChar) &&
                        typedChar.runes.length == 1 &&
                        expectedChar.runes.length >= 2 &&
                        typedChar.runes.first == expectedChar.runes.first &&
                        Letters.meiLetters.contains(
                            String.fromCharCode(typedChar.runes.first))) ||
                    _isLeftDiacriticWaitingForCombo(expectedChar, typedChar) ||
                    _isPartialGraphemeCluster(expectedChar, typedChar));
            final isIncorrect = typedChar != expectedChar && !isPartialInput;

            if (isIncorrect) {
              // Vibrate when an incorrect character is detected
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted) {
                  final hasVibrator = await Vibration.hasVibrator();
                  if (hasVibrator == true) {
                    Vibration.vibrate(duration: 200);
                  }
                }
              });
            }
          }
        }
        // If input decreased (backspace), update tracking but don't vibrate
      }
      // Update previous input for next comparison (always, even on first build)
      _previousInput = normalizedInput;
    } else {
      // Reset tracking when haptic is disabled
      _previousInput = null;
    }

    // ⭐ Widget ---------------------------------
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Gap(context).gap(16),
          vertical: Gap(context).gap(14),
        ),
        child: AnimatedBuilder(
          animation: _cursorAnimation,
          builder: (context, _) {
            return RichText(
              key: ValueKey(widget.paragraph),
              text: TextSpan(
                children: _buildTextSpans(
                  context,
                  widget.paragraph,
                  widget.userInput,
                  practiceConfig,
                  sessionStatus,
                  _cursorAnimation.value,
                ), // TODO: Pass Practice config here
                style: TextStyle(
                  color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                  fontSize: KxScale(context).sp(
                    practiceConfig.contentFontSize.value,
                  ), // 👈 CONTENT FONT SIZE SETTINGS // TODO: add practice config text font size
                  height: 1.5,
                  fontFamily: 'NotoSansTamil',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(
    BuildContext context,
    String paragraph,
    String input,
    PracticeConfig practiceConfig,
    SessionHandler sessionStatus,
    double cursorOpacity,
  ) {
    // Normalize both to NFC form
    final normalizedPara = unorm.nfc(paragraph);
    final normalizedInput = unorm.nfc(input);

    final paraClusters = normalizedPara.characters.toList();
    final inputClusters = normalizedInput.characters.toList();

    final spans = <InlineSpan>[];
    int inputIndex = 0;
    final currentInputLength = inputClusters.length;
    bool isInWaitingState =
        false; // Track if we're waiting from a previous iteration

    // If the fully-normalized strings are equal, the user input matches the
    // target exactly. In this case, highlight everything as correct and skip
    // all per-character "waiting"/error logic to avoid false negatives due
    // to grapheme cluster differences (e.g. க + ள் vs கள்).
    final bool isExactMatch = normalizedPara == normalizedInput;
    if (isExactMatch) {
      for (final paraChar in paraClusters) {
        spans.add(
          TextSpan(
            text: paraChar,
            style: TextStyle(
              color: Colors.green.shade700,
              backgroundColor: getFigmaColor(
                context,
                'State Layers/Success/Opacity-10',
              ),
            ),
          ),
        );
      }
      return spans;
    }

    for (int i = 0; i < paraClusters.length; i++) {
      final paraChar = paraClusters[i];

      // Compare prefixes of the *full* strings up to this visual position.
      // If the normalized input matches the normalized paragraph up to here,
      // we should treat this position as correct even if grapheme clustering
      // split things differently (e.g. க + ள் vs கள்).
      final expectedPrefix = paraClusters.take(i + 1).join();
      final typedPrefix = inputClusters
          .take(currentInputLength < i + 1 ? currentInputLength : i + 1)
          .join();
      final bool isPrefixExactlyCorrect =
          typedPrefix.isNotEmpty && typedPrefix == expectedPrefix;

      // First, check if we have typed input at this position
      // If we're already in a waiting state, don't use the same typed character for other paraChars
      String? typed = (!isInWaitingState && inputIndex < inputClusters.length)
          ? inputClusters[inputIndex]
          : null;

      // If the prefix up to this position matches, forcibly treat this visual
      // position as correct and skip "waiting" logic.
      final bool forceCorrectHere = isPrefixExactlyCorrect;
      if (forceCorrectHere) {
        typed = paraChar;
        isInWaitingState = false;
      }

      // Check if we're waiting for a 2-character diacritic combination to complete
      bool isWaitingForSecondChar = false;

      if (!forceCorrectHere) {
        // First, check if the expected character is a special multi-character sequence
        // Examples: "க்ஷ", "ஸ்ரீ"
        if (_isSpecialMultiCharSequence(paraChar) && typed != null) {
          if (typed == paraChar) {
            // Special sequence is complete, proceed normally
            isWaitingForSecondChar = false;
          } else if (_isPartialSpecialSequence(paraChar, typed)) {
            // Typed is a partial match of the special sequence
            // Wait for the complete sequence
            final isLastTypedChar = inputIndex == currentInputLength - 1;
            if (isLastTypedChar) {
              isWaitingForSecondChar = true;
              isInWaitingState = true;
            }
          }
        }
        // Expected is க்ஷ + diacritic (e.g. க்ஷா, க்ஷொ); typed is க்ஷ — wait for diacritic
        else if (typed != null &&
            _isKshaWithDiacritic(paraChar) &&
            unorm.nfc(typed) == unorm.nfc('க்ஷ')) {
          final isLastTypedChar = inputIndex == currentInputLength - 1;
          if (isLastTypedChar) {
            isWaitingForSecondChar = true;
            isInWaitingState = true;
          }
        }
        // Check if the expected character is a 2-char combination (mei + right diacritic)
        // Examples: பி, வீ, வி, etc.
        else if (_isTwoCharDiacriticCombination(paraChar) && typed != null) {
          // Check if typed matches the full combination (complete)
          if (typed == paraChar) {
            // Combination is complete, proceed normally
            isWaitingForSecondChar = false;
          } else {
            // Check if typed is just the mei part (single rune) and we're at the end of input
            // This means user is actively typing and might be in the process of completing the combination
            final paraRunes = paraChar.runes.toList();
            if (paraRunes.length == 2) {
              final expectedMei = String.fromCharCode(paraRunes[0]);
              final typedRunes = typed.runes.toList();

              // Only wait if:
              // 1. Typed is a single rune (just the mei part)
              // 2. Typed mei matches expected mei
              // 3. We're at the last typed character (user is actively typing)
              if (typedRunes.length == 1) {
                final typedChar = String.fromCharCode(typedRunes[0]);
                final isLastTypedChar = inputIndex == currentInputLength - 1;

                if (typedChar == expectedMei &&
                    Letters.meiLetters.contains(typedChar) &&
                    isLastTypedChar) {
                  // User is typing the mei, waiting for the diacritic
                  isWaitingForSecondChar = true;
                  isInWaitingState = true; // Mark that we're in waiting state
                }
              }
              // If typed has multiple runes or doesn't match, it's a complete (but possibly incorrect) character
            }
          }
        }
        // Generic partial multi-rune cluster: treat as "waiting" if typed is a rune-prefix
        else if (typed != null &&
            _isPartialGraphemeCluster(paraChar, typed) &&
            inputIndex == currentInputLength - 1) {
          isWaitingForSecondChar = true;
          isInWaitingState = true;
        }
      }

      final isCorrect =
          typed != null && typed == paraChar && !isWaitingForSecondChar;
      final isSpace = _isSpace(paraChar);
      final isCombinedForm = _isCombinedLetterForm(paraChar);
      // If waiting for second char, cursor should stay on this character
      // Otherwise, show cursor if this is the next character to type (and not already typed)
      final isUpcoming =
          isWaitingForSecondChar || (i == currentInputLength && typed == null);

      // Determine text color and background based on three-color system
      Color textColor;
      Color? backgroundColor;
      TextDecoration? decoration;
      Color? decorationColor;
      double? decorationThickness;

      // In blind mode, only show cursor - everything else is neutral
      // Blind mode should only apply to practice mode, not challenge mode
      if (practiceConfig.blindMode &&
          sessionStatus.mode == SessionMode.practice) {
        if (isUpcoming || isWaitingForSecondChar) {
          // Upcoming character - blue with blinking underscore cursor underneath
          textColor = Colors.blue.shade600;
          backgroundColor = null;
          decoration = TextDecoration.none;
        } else {
          // All typed characters and untyped characters - neutral grey, no highlighting
          textColor = Colors.grey.shade600;
          backgroundColor = null;
          decoration = TextDecoration.none;
        }
      } else {
        // Normal mode with full highlighting
        if (isWaitingForSecondChar) {
          // Waiting for second character of 2-char combination - show partial with secondary color
          textColor = getFigmaColor(context, 'Schemes/Secondary');
          backgroundColor = getFigmaColor(
            context,
            'State Layers/Secondary/Opacity-10',
          );
          decoration = TextDecoration.none;
        } else if (isUpcoming) {
          // Upcoming character - blue with blinking underscore cursor underneath
          textColor = Colors.blue.shade600;
          backgroundColor = null;
          decoration = TextDecoration.none;
        } else if (typed == null) {
          // Not yet typed - grey
          textColor = Colors.grey.shade400;
          backgroundColor = null;
          decoration = TextDecoration.none;
        } else if (isSpace) {
          // Space character - neutral blue-grey for clarity
          textColor = isCorrect ? Colors.blueGrey.shade400 : Colors.red;
          backgroundColor = isCorrect
              ? Colors.green.shade100
              : Colors.red.shade100;
          decoration = TextDecoration.none;
          decorationColor = isSpace ? textColor : null;
          decorationThickness = 1.5;
        } else if (isCorrect) {
          // Correct character (combined or simple) - dark green with light green background
          textColor = Colors.green.shade700;
          backgroundColor = getFigmaColor(
            context,
            'State Layers/Success/Opacity-10',
          );
          decoration = TextDecoration.none;
        } else if (!isCorrect && isCombinedForm) {
          // Incorrect combined letter form - secondary color (orange)
          textColor = getFigmaColor(context, 'Schemes/Secondary');
          backgroundColor = getFigmaColor(
            context,
            'State Layers/Secondary/Opacity-10',
          );
          decoration = TextDecoration.none;
        } else {
          // Incorrect simple character - red with light red background
          textColor = Colors.red.shade700;
          backgroundColor = getFigmaColor(
            context,
            'State Layers/Error/Opacity-10',
          );
          decoration = TextDecoration.none;
        }
      }

      // For upcoming character or waiting for second char, use WidgetSpan to add underscore cursor underneath
      if (isUpcoming || isWaitingForSecondChar) {
        // Always show the full expected character (paraChar) so user can see what to type
        // including the pulli/diacritic. The waiting state is just a visual indicator (secondary color).
        final charToShow = paraChar;

        spans.add(
          WidgetSpan(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Text(
                  charToShow,
                  style: TextStyle(
                    color: textColor,
                    backgroundColor: backgroundColor,
                    fontSize: KxScale(
                      context,
                    ).sp(practiceConfig.contentFontSize.value),
                    height: 1.5,
                    fontFamily: 'NotoSansTamil',
                  ),
                ),
                Positioned(
                  bottom: -2,
                  child: Opacity(
                    opacity: cursorOpacity,
                    child: Text(
                      '_',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: KxScale(
                          context,
                        ).sp(practiceConfig.contentFontSize.value),
                        height: 1.0,
                        fontFamily: 'NotoSansTamil',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Show the expected character (paraChar) - this ensures the full expected character
        // like "ற்" is visible even when user types just 'ற'
        spans.add(
          TextSpan(
            text: paraChar,
            style: TextStyle(
              color: textColor,
              backgroundColor: backgroundColor,
              decoration: decoration,
              decorationColor: decorationColor,
              decorationThickness: decorationThickness,
            ),
          ),
        );
      }

      // Advance inputIndex after processing this paraChar
      // CRITICAL: When waiting, we DON'T advance inputIndex so we can match the combined
      // character when the user types the diacritic. The keyboard combines 'த' + '்' into 'த்',
      // so inputClusters[inputIndex] will update from 'த' to 'த்' on next render.
      if (!isWaitingForSecondChar) {
        inputIndex++;
        isInWaitingState = false; // Reset waiting state when we advance
      }
      // When waiting, inputIndex stays the same, and isInWaitingState prevents
      // using the same typed character for subsequent paraChars
    }

    return spans;
  }
}
