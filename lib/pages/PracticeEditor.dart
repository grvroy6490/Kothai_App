// Full Working PracticeEditor with Real-Time WPM, Accuracy, Time

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/Letters.dart';
import 'package:kothai_app/pages/practiceEditor/CustomKeyboard.dart';
import 'package:kothai_app/pages/practiceEditor/FooterNavigation/FooterNavigationBar.dart';
import 'package:kothai_app/pages/practiceEditor/InfoBadge.dart';
import 'package:kothai_app/pages/practiceEditor/PracticeTopBar.dart';
import 'package:kothai_app/pages/practiceEditor/StatBadge.dart';
import 'package:kothai_app/provider/HoldingKeyModel.dart';
import 'package:kothai_app/provider/StartStopPracticeModel.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/widgets/DifficultySegmentedButton.dart';
import 'package:provider/provider.dart';

class PracticeEditor extends StatefulWidget {
    const PracticeEditor({super.key});

    @override
    State<PracticeEditor> createState() => _PracticeEditorState();
}

class _PracticeEditorState extends State<PracticeEditor> {
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();
    final String easy = "இறந்தலின் புகழ் வரை சொல்லாமலோ? மறைந்தது வாயில்பு வளர்க்காதில்லை? நட்புகளீஸில் பூத்தப";
    final String hard = "அந்திநேரத்திலும் அலைபாயும் கடற்கரைச் சுழற்சி, வாழ்க்கையின் விளிம்புகளில் விழுந்து மீண்டு எழும் ஒரு துடிப்பே போன்றது. \"ஃபெரியொட்டிப் பிழிவுகள்\" என்ற பேச்சும், 'ஈரல்' என்ற வினோத சொல்லும், கட்டுக்கதை போலவே சிக்கலாகச் செறிந்த வாசகங்கள் இங்கே பயிற்சிக்காக வந்துள்ளன. ப்ளூட்டோவையும் ஃபிலாஃபலையும் வரிசையாக இடுக!";
    late String paragraph;

    String userInput = "";
    String? lastTypedLetter;

    DateTime? _startTime;
    Duration _elapsed = Duration.zero;
    Timer? _timer;  

    int get wordCount => userInput.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    double get timeInMinutes => _elapsed.inSeconds / 60.0;

    double get wpm => (timeInMinutes > 0 && wordCount > 0) ? wordCount / timeInMinutes : 0;

    double get accuracy {
        int correct = 0;
        for (int i = 0; i < userInput.length && i < paragraph.length; i++) {
            if (userInput[i] == paragraph[i]) correct++;
        }
        return userInput.isEmpty ? 0 : (correct / userInput.length) * 100;
    }

    double get progress => (userInput.length / paragraph.length) * 100;

    void startTimer() {
        _startTime ??= DateTime.now();
        _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
                setState(() {
                        _elapsed = DateTime.now().difference(_startTime!);
                    });
            });
    }

    void stopTimer() {
        _timer?.cancel();
        _timer = null;
    }

    void handleKeyPress(BuildContext context, String data) {
        final text = _controller.text;
        final selection = _controller.selection;
        if (!selection.isValid) return;

        startTimer();

        final holdModel = context.read<HoldKeyModel>();

        if (lastTypedLetter == null &&
            (Letters.rightDiacritic.contains(data) ||
                Letters.leftDiacritic.contains(data) ||
                data == 'space' || data == 'delete')) return;

        if (lastTypedLetter != null &&
            Letters.uyir.contains(lastTypedLetter) &&
            (Letters.rightDiacritic.contains(data) || Letters.leftDiacritic.contains(data))) return;

        if (Letters.leftDiacritic.contains(data)) {
            holdModel.holdFor(data);
            return;
        }

        if (data == 'lang') {
            return;
        }

        if (data == 'space') {
            holdModel.clear();
            return handleSpace(text, selection);
        }

        if (data == 'enter') {
            holdModel.clear();
            return handleEnter(text, selection);
        }

        if (data == 'delete') {
            holdModel.clear();
            return handleDelete(text, selection);
        }

        String toInsert = data;
        if (holdModel.isHolding) {
            final isBase = !Letters.leftDiacritic.contains(data) &&
                !Letters.rightDiacritic.contains(data) &&
                data != ' ' && data != 'delete';

            if (isBase) {
                toInsert = data + (holdModel.hold ?? '');
                holdModel.clear();
            }
        }

        final newText  = text.replaceRange(selection.start, selection.end, toInsert);
        final newInput = userInput.replaceRange(selection.start, selection.end, toInsert);

        setState(() {
                _controller.text = newText;
                _controller.selection = TextSelection.collapsed(offset: selection.start + toInsert.length);
                userInput = newInput;
                lastTypedLetter = data;
            });
    }

    void handleEnter(String text, TextSelection selection) {
        final newText = text.replaceRange(selection.start, selection.end, '\n');
        final newInput = userInput.replaceRange(selection.start, selection.end, '\n');

        setState(() {
                _controller.text = newText;
                _controller.selection = TextSelection.collapsed(offset: selection.start + 1);
                userInput = newInput;
                lastTypedLetter = '\n';
            });
    }

    void handleSpace(String text, TextSelection selection) {
        final newText  = text.replaceRange(selection.start, selection.end, ' ');
        final newInput = userInput.replaceRange(selection.start, selection.end, ' ');

        setState(() {
                _controller.text = newText;
                _controller.selection = TextSelection.collapsed(offset: selection.start + 1);
                userInput = newInput;
                lastTypedLetter = ' ';
            });
    }

    void handleDelete(String text, TextSelection selection) {
        if (selection.start != selection.end) {
            final newText  = text.replaceRange(selection.start, selection.end, '');
            final newInput = userInput.replaceRange(selection.start, selection.end, '');

            setState(() {
                    _controller.text = newText;
                    _controller.selection = TextSelection.collapsed(offset: selection.start);
                    userInput = newInput;
                    lastTypedLetter = selection.start > 0 ? newInput[selection.start - 1] : null;
                });
        } else if (selection.start > 0) {
            final newText  = text.replaceRange(selection.start - 1, selection.start, '');
            final newInput = userInput.replaceRange(selection.start - 1, selection.start, '');

            setState(() {
                    _controller.text = newText;
                    _controller.selection = TextSelection.collapsed(offset: selection.start - 1);
                    userInput = newInput;
                    lastTypedLetter = newInput.isNotEmpty
                        ? newInput[(selection.start - 2 >= 0) ? selection.start - 2 : 0]
                        : null;
                });
        } else {
            setState(() {
                    lastTypedLetter = null;
                });
        }
    }

    @override
    void initState() {
        super.initState();
        paragraph = easy;
    }

    void updateDifficulty(Difficulty difficulty) {
        print(difficulty);
        setState(() {
                // Change paragraph
                paragraph = (difficulty == Difficulty.easy) ? easy : hard;

                // Reset typing state
                userInput = "";
                lastTypedLetter = null;

                // Reset timer
                _startTime = null;
                _elapsed = Duration.zero;
                _timer?.cancel();
                _timer = null;

                // Reset controller
                _controller.text = "";
                _controller.selection = const TextSelection.collapsed(offset: 0);
            });

        // Refocus the hidden textfield to accept input
        Future.delayed(Duration(milliseconds: 100), () {
                if (!_focusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(_focusNode);
                }
            });
    }

    @override
    void dispose() {
        _controller.dispose();
        _focusNode.dispose();
        _timer?.cancel();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final isPracticeRunning = context.watch<StartStopPracticeModel>().isPracticeRunning;

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: SafeArea(
                child: Stack(
                    children: [
                        Column(
                            children: [
                                buildPracticeTopBar(context),
                                Padding(padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0
                                    ),
                                    child: AnimatedCrossFade(
                                        duration: const Duration(milliseconds: 500),
                                        crossFadeState: isPracticeRunning ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                        firstChild: Row(
                                            spacing: 5,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                                Expanded(child: InfoBadge(context: context, label: 'Words', value: '90')),
                                                Expanded(child: InfoBadge(context: context, label: 'Time', value: '~2m'))
                                            ],
                                        ),
                                        secondChild: Row(
                                            spacing: 5,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                                Expanded(child: StatBadge(context: context, label: wpm.toStringAsFixed(0), value: 'WPM')),
                                                Expanded(child: StatBadge(context: context, label: '${accuracy.toStringAsFixed(1)}%', value: 'Accuracy')),
                                                Expanded(child: StatBadge(context: context, label: '${_elapsed.inMinutes}m ${_elapsed.inSeconds % 60}s', value: 'Time'))
                                            ],
                                        ),
                                    ),
                                ),
                                Expanded(
                                    child: Stack(
                                        children: [
                                            // TextField(
                                            //     controller: _controller,
                                            //     focusNode: _focusNode,
                                            //     readOnly: true,
                                            //     autofocus: true,
                                            //     enableInteractiveSelection: false,
                                            //     maxLines: null,
                                            // ),
                                            SingleChildScrollView(
                                                padding: const EdgeInsets.all(16),
                                                child: RichText(
                                                    key: ValueKey(paragraph),
                                                    text: TextSpan(
                                                        children: _buildTextSpans(paragraph, userInput),
                                                        style: const TextStyle(fontSize: 24, fontFamily: 'NotoSansTamil'),
                                                    ),
                                                ),
                                            ),
                                            Positioned(
                                                left: -1000,
                                                child: SizedBox(
                                                    width: 1,
                                                    height: 1,
                                                    child: TextField(
                                                        controller: _controller,
                                                        focusNode: _focusNode,
                                                        readOnly: true,
                                                        autofocus: true,
                                                        enableInteractiveSelection: false,
                                                        maxLines: null,
                                                    ),
                                                ),
                                            )
                                        ],
                                    ),
                                )
                            ],
                        ),
                        FooterNavigationBar(updateDifficulty: updateDifficulty,),
                        CustomKeyboard(
                            context: context,
                            handleKeyPress: (data) => handleKeyPress(context, data),
                        )
                    ],
                ),
            ),
        );
    }

    List<TextSpan> _buildTextSpans(String paragraph, String input) {
        return List.generate(paragraph.length, (i) {
                final actualChar = paragraph[i];
                final typedChar = (i < input.length) ? input[i] : null;

                bool isCorrect = typedChar != null && typedChar == actualChar;

                Color textColor;
                Color? bgColor;

                if (typedChar == null) {
                    textColor = Colors.grey.shade400;
                } else if (isCorrect) {
                    textColor = Colors.green;
                } else {
                    textColor = Colors.red;
                }

                // Highlight space with subtle background
                if (actualChar == ' ') {
                    // bgColor = Colors.black12;
                }

                return TextSpan(
                    text: actualChar,
                    style: TextStyle(
                        color: textColor,
                        backgroundColor: bgColor,
                        fontSize: 24,
                        fontFamily: 'NotoSansTamil',
                    ),
                );
            });
    }

}
