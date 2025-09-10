import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/providers/content/text_provider.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/AnimatedContentBoard.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/PracticeInfoBox.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/PracticeStartWidget.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/TypingProgressBar.dart';

class EditorArea extends ConsumerStatefulWidget {
    final TextEditingController controller;
    final FocusNode focusNode;
    const EditorArea({
        super.key,
        required this.controller,
        required this.focusNode,
    });

    @override
    ConsumerState<EditorArea> createState() => _EditorAreaState();
}

class _EditorAreaState extends ConsumerState<EditorArea>
    with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _fadeAnimation;

    String placeholderText = "அந்திநேரத்திலும் அலைபாயும் கடற்கரைச் சுழற்சி, வாழ்க்கையின் விளிம்புகளில் விழுந்து மீண்டு எழும் ஒரு துடிப்பே போன்றது. \"ஃபெரியொட்டிப் பிழிவுகள்\" என்ற பேச்சும், 'ஈரல்' என்ற வினோத சொல்லும், கட்டுக்கதை போலவே சிக்கலாகச் செறிந்த வாசகங்கள் இங்கே பயிற்சிக்காக வந்துள்ளன. ப்ளூட்டோவையும் ஃபிலாஃபலையும் வரிசையாக இடுக!";
    late String paragraph;

    String userInput = "";

    PracticeStatus? _lastStatus;
    late VoidCallback _controllerListener;

    @override
    void initState() {
        super.initState();
        _animationController = AnimationController(
            duration: Duration(milliseconds: 600),
            vsync: this,
        );

        _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        // Bind userInput to the controller's text
        userInput = widget.controller.text;
        _controllerListener = () {
            if (mounted) {
                setState(() {
                        userInput = widget.controller.text;
                    });
            }
        };
        widget.controller.addListener(_controllerListener);
    }

    @override
    void dispose() {
        widget.controller.removeListener(_controllerListener);
        widget.controller.dispose();
        widget.focusNode.dispose();
        _animationController.dispose();
        super.dispose();
    }

    // HANDLE PRACTICE CHANGE STATUS
    void _handlePracticeStatusChange(PracticeStatus status) {
        if (_lastStatus != status) {
            if (_lastStatus != PracticeStatus.start &&
                status == PracticeStatus.start) {
                // Practice just started, fade out the start block
                _animationController.forward();
                // Focus the text field when practice starts
                widget.focusNode.requestFocus();
            } else if (_lastStatus == PracticeStatus.start &&
                status != PracticeStatus.start) {
                // Practice reset, fade in the start block
                _animationController.reverse();
                // Remove focus when practice stops
                widget.focusNode.unfocus();
                if (mounted) {
                    setState(() {
                            widget.controller.clear();
                            userInput = '';
                        });
                }
            }
            _lastStatus = status;
        }
    }

    @override
    Widget build(BuildContext context) {
        final practiseStatus = ref.watch(practiceStatusProvider);

        final fetchContent = ref.watch(textContentProvider);
        if(fetchContent != null){
            paragraph = "1234567890987654321";
        } else {
            paragraph = placeholderText;
        }
        // Handle fade animation on status change
        WidgetsBinding.instance.addPostFrameCallback((_) {
                _handlePracticeStatusChange(practiseStatus);
            });

        return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.only(top: 3),
            child: Stack(
                clipBehavior: Clip.none,
                children: [
                    // PROGRESS BAR
                    Positioned(
                        top: -3,
                        left: 0,
                        right: 0,
                        child: TypingProgressBar(width: 0.5),
                    ),

                    // BACKGROUND
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: practiseStatus == PracticeStatus.start
                                ? getFigmaColor(context, 'Schemes/Background')
                                : getFigmaColor(context, 'Schemes/Surface Container'),
                        ),
                        clipBehavior: Clip.hardEdge,
                    ),

                    // BOTTOM SHADOW + SLIDE-UP CONTENT
                    Container(
                        height: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withAlpha(20)],
                                stops: const [0.95, 1.0],
                            ),
                        ),
                    ),

                    // SURFACE CONTAINER
                    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                            children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch, // optional but nice
                                    children: [
                                        PracticeInfoBox(),

                                        AnimatedContentBoard(
                                            paragraph: paragraph,
                                            userInput: userInput,
                                        ),
                                    ],
                                ),

                                Positioned.fill(
                                    child: IgnorePointer(
                                        ignoring: true, // <- key change: don't intercept taps/scrolls
                                        child: Opacity(
                                            opacity: 0.0,
                                            child: TextField(
                                                controller: widget.controller,
                                                focusNode: widget.focusNode,
                                                readOnly: true,
                                                showCursor: true,
                                                enableInteractiveSelection: false,
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.zero,
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),

                    // PRACTICE START BLOCK
                    PracticeStartWidget(fadeAnimation: _fadeAnimation),
                ],
            ),
        );
    }
}
