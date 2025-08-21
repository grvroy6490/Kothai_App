import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keyboard.dart';
import 'package:kothai_app/keyboard/letters.dart';

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

        if (selection.isValid) {

            if(
                lastTypedLetter == null &&
                Letters.rightDiacritic.contains(data)
            ) {
                // If the same letter is pressed again, do nothing
                return;
            }

            if(lastTypedLetter != null){
                // If the last typed letter is a right diacritic, we should not allow typing another letter
                if (
                    Letters.uyir.contains(lastTypedLetter) &&
                    Letters.rightDiacritic.contains(data)
                ) {
                    return;
                }
            }

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
                body: Stack(
                    children: [
                        // Background
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color.fromARGB(255, 64, 68, 76),
                            child: Column(
                                children: [
                                    // Header
                                    SizedBox(
                                        height: 150,
                                        child: Center(
                                            child: Text(
                                                'Kothai Practice Editor',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ),
                                    ),

                                    // Typing Area
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                                setState(() {
                                                        showBottomPanel = !showBottomPanel;
                                                    });
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(255, 237, 238, 241),
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20),
                                                    ),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                        Text(
                                                            'Tap to lift keys',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Colors.black87,
                                                                fontSize: 20,
                                                            ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        // SingleChildScrollView(
                                                        //     child: Padding(padding: EdgeInsets.only(
                                                        //             bottom: MediaQuery.of(context).viewInsets.bottom,
                                                        //         ),
                                                        //         child: Text(
                                                        //             'அந்திநேரத்திலும் அலைபாயும் கடற்கரைச் சுழற்சி, வாழ்க்கையின் விளிம்புகளில் விழுந்து மீண்டு எழும் ஒரு துடிப்பே போன்றது. "ஃபெரியொட்டிப் பிழிவுகள்" என்ற பேச்சும், \'ஈரல்\' என்ற வினோத சொல்லும், கட்டுக்கதை போலவே சிக்கலாகச் செறிந்த வாசகங்கள் இங்கே பயிற்சிக்காக வந்துள்ளன. ப்ளூட்டோவையும் ஃபிலாஃபலையும் வரிசையாக இடுக!',
                                                        //             style: TextStyle(
                                                        //                 fontSize: 25,
                                                        //                 height: 1.5,
                                                        //                 color: Colors.black87,
                                                        //                 fontFamily: 'NotoSansTamil',
                                                        //             ),
                                                        //         ),
                                                        //     )
                                                        // )
                                                        AnimatedContainer(
                                                            duration: const Duration(milliseconds: 300),
                                                            curve: Curves.easeInOut,
                                                            height: showBottomPanel
                                                                ? screenHeight * 0.4
                                                                : screenHeight * 0.67,
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10),
                                                                boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors.black12,
                                                                        blurRadius: 5,
                                                                        spreadRadius: 1,
                                                                    ),
                                                                ],
                                                            ),
                                                            padding: const EdgeInsets.all(12),
                                                            child: TextField(
                                                                controller: _controller,
                                                                focusNode: _focusNode,
                                                                style: const TextStyle(
                                                                    fontSize: 20,
                                                                    height: 1.5,
                                                                    fontFamily: 'NotoSansTamil',
                                                                    color: Colors.black,
                                                                ),
                                                                readOnly: true,
                                                                expands: true,
                                                                maxLines: null,
                                                                decoration: const InputDecoration.collapsed(
                                                                    hintText: 'Start typing here...',
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),

                        // Animated Bottom Panel (Custom Keyboard)
                        AnimatedPositioned(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            bottom: showBottomPanel ? 0 : -MediaQuery.of(context).size.height,
                            left: 0,
                            right: 0,
                            child: Container(
                                constraints: BoxConstraints(minHeight: 50),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 233, 234, 238),
                                    border: Border(
                                        top: BorderSide(color: Colors.black12),
                                    ),
                                ),
                                child: Keyboard(
                                    onKeyPressed: handleKeyPress,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
