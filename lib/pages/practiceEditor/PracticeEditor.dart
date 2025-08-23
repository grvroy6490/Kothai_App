import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/Keyboard.dart';
import 'package:kothai_app/keyboard/Letters.dart';
import 'package:kothai_app/pages/practiceEditor/CustomKeyboard.dart';
import 'package:kothai_app/pages/practiceEditor/FooterNavigation/FooterNavigationBar.dart';
import 'package:kothai_app/pages/practiceEditor/InfoBadge.dart';
import 'package:kothai_app/pages/practiceEditor/PracticeTopBar.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/widgets/Level_XP_Badge.dart';

class PracticeEditor extends StatefulWidget {
    const PracticeEditor({super.key});

    @override
    State<PracticeEditor> createState() => _PracticeEditorState();
}

class _PracticeEditorState extends State<PracticeEditor> {
    bool showBottomPanel = false;
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();

    // Add this as a field in _PracticeEditorState
    String? lastTypedLetter;

    void handleKeyPress(String data) {
        final text = _controller.text;
        final selection = _controller.selection;

        // KEY VALIDATIONS
        if (selection.isValid) {

            if(lastTypedLetter == null &&
                (Letters.rightDiacritic.contains(data) || Letters.leftDiacritic.contains(data) || data == 'space' || data == 'delete')
            ) {
                // If the same letter is pressed again, do nothing
                return;
            }

            if (lastTypedLetter != null) {
                // If the last typed letter is uyir and the new data is a right or left diacritic, do not allow typing
                if (
                Letters.uyir.contains(lastTypedLetter) &&
                    (Letters.rightDiacritic.contains(data) || Letters.leftDiacritic.contains(data))
                ) {
                    return;
                }
            }

            // Final text update
            if (data == 'space') {
                handleSpace(text, selection);
            } else if (data == 'delete') {
                handleDelete(text, selection);
            } else {
                final newText = text.replaceRange(selection.start, selection.end, data);
                setState(() {
                        _controller.text = newText;
                        _controller.selection = TextSelection.collapsed(offset: selection.start + data.length);
                        lastTypedLetter = data;
                    });
            }
        }
    }

    void handleSpace(text, selection) {
        if (selection.isValid) {
            final newText = text.replaceRange(selection.start, selection.end, ' ');
            setState(() {
                    _controller.text = newText;
                    _controller.selection = TextSelection.collapsed(offset: selection.start + 1);
                    lastTypedLetter = ' ';
                });
        }
    }

    void handleDelete(text, selection) {
        if (selection.start != selection.end) {
            final newText = text.replaceRange(selection.start, selection.end, '');
            setState(() {
                    _controller.text = newText;
                    _controller.selection = TextSelection.collapsed(offset: selection.start);
                    lastTypedLetter = selection.start > 0 ? newText[selection.start - 1] : null;
                });
        } else if (selection.start > 0) {
            final newText = text.replaceRange(selection.start - 1, selection.start, '');
            setState(() {
                    _controller.text = newText;
                    _controller.selection = TextSelection.collapsed(offset: selection.start - 1);
                    lastTypedLetter = selection.start - 1 > 0 ? newText[selection.start - 2] : (newText.isNotEmpty ? newText[0] : null);
                });
        } else {
            setState(() {
                    lastTypedLetter = null;
                });
        }
    }

    @override
    void dispose() {
        _controller.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return SafeArea(
            child: Scaffold(
                backgroundColor: getFigmaColor(context, 'Schemes/Background'),
                body: Stack(
                    children: [
                        // Background
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: getFigmaColor(context, 'Schemes/Background'),
                            child: Column(
                                children: [
                                    // Top Bar
                                    BuildPracticeTopBar(context),

                                    // Typing Area
                                    Expanded(
                                        child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                                color: getFigmaColor(context, 'Schemes/Surface Container'),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(24),
                                                ),
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                    Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 16, vertical: 10,
                                                        ),
                                                        child: Row(
                                                            spacing: 15,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(child: InfoBadge(
                                                                        context: context,
                                                                        label: 'Words',
                                                                        value: '90 (~500 Character)'
                                                                    )),
                                                                Expanded(child: InfoBadge(
                                                                        context: context,
                                                                        label: 'Avg. Time @ 40 WPM',
                                                                        value: '~2 mins 20 secs',
                                                                        icon: FontAwesomeIcons.clock
                                                                    )),
                                                            ],
                                                        ),
                                                    ),

                                                    SizedBox(height: 5),

                                                    // Typing Area
                                                    AnimatedContainer(
                                                        duration: const Duration(milliseconds: 300),
                                                        curve: Curves.easeInOut,
                                                        height: showBottomPanel
                                                            ? screenHeight * 0.45
                                                            : screenHeight * 0.7,
                                                        decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.circular(10),
                                                            // boxShadow: const [
                                                            //     BoxShadow(
                                                            //         color: Colors.black12,
                                                            //         blurRadius: 5,
                                                            //         spreadRadius: 1,
                                                            //     ),
                                                            // ],
                                                        ),
                                                        padding: const EdgeInsets.all(12),
                                                        child: TextField(
                                                            controller: _controller,
                                                            focusNode: _focusNode,
                                                            style: const TextStyle(
                                                                fontSize: 24,
                                                                height: 1.5,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'NotoSansTamil',
                                                                color: Color.fromARGB(255, 74, 69, 77),
                                                            ),
                                                            readOnly: true,
                                                            expands: true,
                                                            maxLines: null,
                                                            decoration: const InputDecoration.collapsed(
                                                                hintStyle: TextStyle(
                                                                    color: Color.fromARGB(100, 74, 69, 77),
                                                                    fontSize: 24,
                                                                    height: 1.5,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: 'NotoSansTamil',
                                                                ),
                                                                hintText: 'அந்திநேரத்திலும் அலைபாயும் கடற்கரைச் சுழற்சி, வாழ்க்கையின் விளிம்புகளில் விழுந்து மீண்டு எழும் ஒரு துடிப்பே போன்றது. "ஃபெரியொட்டிப் பிழிவுகள்" என்ற பேச்சும், \'ஈரல்\' என்ற வினோத சொல்லும், கட்டுக்கதை போலவே சிக்கலாகச் செறிந்த வாசகங்கள் இங்கே பயிற்சிக்காக வந்துள்ளன. ப்ளூட்டோவையும் ஃபிலாஃபலையும் வரிசையாக இடுக!',
                                                            ),
                                                        ),
                                                    ),

                                                ],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),

                        // Footer Navigation Bar
                        FooterNavigationBar(),

                        // Animated Bottom Panel (Custom Keyboard)
                        CustomKeyboard(
                            context: context,
                            handleKeyPress: handleKeyPress
                        )
                    ],
                ),
            ),
        );
    }
}
