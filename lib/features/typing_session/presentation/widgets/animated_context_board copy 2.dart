import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:logger/logger.dart';
import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/letters.dart';
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

  @override
  Widget build(BuildContext context) {
    // 🌐 PROVIDERS ------------------------------
    final practiceConfig = ref.watch(practiceConfigurationProvider);
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
            final isIncorrect = typedChar != expectedChar;

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

    for (int i = 0; i < paraClusters.length; i++) {
      final paraChar = paraClusters[i];
      final typed = (inputIndex < inputClusters.length)
          ? inputClusters[inputIndex]
          : null;

      final isCorrect = typed != null && typed == paraChar;
      final isSpace = _isSpace(paraChar);
      final isCombinedForm = _isCombinedLetterForm(paraChar);
      final isUpcoming = i == currentInputLength; // Next character to type

      // Determine text color and background based on three-color system
      Color textColor;
      Color? backgroundColor;
      TextDecoration? decoration;
      Color? decorationColor;
      double? decorationThickness;

      if (isUpcoming) {
        // Upcoming character - blue with blinking underscore cursor underneath
        textColor = Colors.blue.shade600;
        backgroundColor = null;
        decoration = TextDecoration.none;
      } else if (typed == null) {
        // Not yet typed - grey
        textColor = Colors.grey.shade400;
        backgroundColor = null;
        decoration = TextDecoration.none;
      } else if (practiceConfig.blindMode) {
        // Blind mode - neutral grey
        textColor = Colors.grey.shade600;
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

      // For upcoming character, use WidgetSpan to add underscore cursor underneath
      if (isUpcoming) {
        spans.add(
          WidgetSpan(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Text(
                  paraChar,
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
        // For spaces, add a visual indicator using underline decoration
        // Keep the space character to maintain proper layout
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

      inputIndex++;
    }

    return spans;
  }
}
