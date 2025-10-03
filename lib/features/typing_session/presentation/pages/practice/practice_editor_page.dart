
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/db_provider.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/complete/practice_complete_page.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/XP/xp_controller.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/progress/practice_progress_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/user_input/user_input_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/practice/practice_session_controller.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/animated_content_board.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/practice_metrics_bar.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/practice_start_button.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/typing_progress.dart';


class PracticeEditorPage extends ConsumerStatefulWidget {
    final TextEditingController controller;
    final FocusNode focusNode;
    const PracticeEditorPage({super.key, required this.controller, required this.focusNode});

    @override
    ConsumerState<PracticeEditorPage> createState() => _PracticeEditorPageState();
}

class _PracticeEditorPageState extends ConsumerState<PracticeEditorPage> {

    late bool showXP;
    late int currentNavIndex;
    late String paragraph;
    int _lastLen = 0;
    String placeholderText = "அந்திநேரத்திலும் அலைபாயும் கடற்கரைச் சுழற்சி, வாழ்க்கையின் விளிம்புகளில் விழுந்து மீண்டு எழும் ஒரு துடிப்பே போன்றது. \"ஃபெரியொட்டிப் பிழிவுகள்\" என்ற பேச்சும், 'ஈரல்' என்ற வினோத சொல்லும், கட்டுக்கதை போலவே சிக்கலாகச் செறிந்த வாசகங்கள் இங்கே பயிற்சிக்காக வந்துள்ளன. ப்ளூட்டோவையும் ஃபிலாஃபலையும் வரிசையாக இடுக!";

    late VoidCallback _controllerListener;

    @override
    void initState() {
        super.initState();
        showXP = true;
        currentNavIndex = 0;

        _controllerListener = () {
            if (!mounted) return;

            final textNow = widget.controller.text;

            // 1) keep your provider in sync
            ref.read(userInputProvider.notifier).set(textNow);

            // 2) compute deltas and call onKey for new chars
            final ctrl = ref.read(practiceSessionControllerProvider.notifier);

            // If user pasted multiple chars, process each new char
            if (textNow.length > _lastLen) {
                for (int i = _lastLen; i < textNow.length; i++) {
                    final received = textNow[i];
                    // Guard against paragraph shorter than input
                    final expected = (i < paragraph.length) ? paragraph[i] : null;
                    final correct = expected != null && received == expected;
                    ctrl.onKey(correct: correct);
                }
            }
            // If user deleted (backspace), we won’t alter metrics here.
            // (If you want to support take-backs: add a ctrl.onBackspace() that adjusts metrics.)

            _lastLen = textNow.length;
            setState(() {
                }); // if you still need a local rebuild
        };

        widget.controller.addListener(_controllerListener);
    }

    @override
    void dispose() {
        widget.controller.removeListener(_controllerListener);
        super.dispose();
    }

    @override
    Widget build(BuildContext ctx) {        
        final practiceStatus = ref.watch(practiceStatusProvider); // 👈 PRACTICE STATUS PROVIDER
        final progress = ref.watch(practiceProgressProvider);
        final fetchContent = ref.watch(textContentProvider); // 👈 PRELOAD TEXT FROM PROVIDER
        if (fetchContent != null) {
            paragraph = fetchContent.content;
        } else {
            paragraph = placeholderText;
        }

        // 👇 HANDLE START
        void handleStartPractice(){
            ref.read(practiceStatusProvider.notifier).startPractice();
            ref.read(practiceSessionControllerProvider.notifier).start();
        }

        // 👇 HANDLE TEXT FIELD FOCUS
        ref.listen<PracticeStatusEnum>(practiceStatusProvider, (prev, next) {
                if (next == PracticeStatusEnum.start) {
                    // focus the text field
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.focusNode.requestFocus();
                        });
                } else {
                    widget.focusNode.unfocus();
                }
            });

        // 👇 LISTEN TO PROGRESS COMPLETION
        ref.listen<double>(practiceProgressProvider, (prev, next) async {
                if (next == 1.0) {
                    ref.read(practiceSessionControllerProvider.notifier).stop();
                    ref.read(practiceStatusProvider.notifier).stopPractice();
                    widget.controller.clear();

                    // 👇 UPDATING XP TO DB VIA CONTROLLER
                    final lastSession = ref.watch(lastSessionStoreProvider).load();
                    lastSession.then((value) async => {
                            await ref.read(xpControllerProvider.notifier).award(
                                amount: 50,
                                mode: 'practice',
                                sessionId: value!.id
                            ),

                            // TODO (optional) try sync if logged in
                            // await ref.read(xpControllerProvider.notifier).syncIfLoggedIn()
                        });

                    Get.to(() => PracticeCompletePage(), transition: Transition.fadeIn, curve: Curves.easeInOut);
                }
            });

        // 👇 WIDGET RETURN
        return SizedBox(
            height: double.infinity,
            child: Padding(
                padding: EdgeInsets.only(top: Gap(context).gap(5)),
                child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                        // TYPING PROGRESS
                        Positioned(
                            top: -3,
                            left: 0,
                            right: 0,
                            child: TypingProgress(width: progress) // 👈 TYPING PROGRESS
                        ),

                        Container(
                            decoration: BoxDecoration(
                                color: getFigmaColor(context, 'Schemes/Surface Container'),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                            ),
                            child: Stack(
                                children: [
                                    Column(
                                        children: [
                                            SizedBox(
                                                height: Gap(context).gap(75),
                                                width: double.infinity,
                                                child: PracticeMetricsBar()  // 👈 PRACTICE METRICS BAR
                                            ),
                                            Flexible(
                                                child: AnimatedContentBoard(
                                                    paragraph: paragraph
                                                )  // 👈 CONTENT BOARD
                                            )
                                        ]
                                    ),

                                    Positioned.fill(
                                        top: MediaQuery.of(context).size.height * 0.3,
                                        child: IgnorePointer(
                                            ignoring: true, // <- key change: don't intercept taps/scrolls
                                            child: Opacity(
                                                opacity: 1,
                                                child: TextFormField(
                                                    maxLines: 2,
                                                    controller: widget.controller,
                                                    focusNode: widget.focusNode,
                                                    readOnly: true,
                                                    showCursor: false,
                                                    enableInteractiveSelection: false,
                                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                                    ),
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black87, width: 1)
                                                        ),
                                                        contentPadding: EdgeInsets.zero
                                                    )
                                                )
                                            )
                                        )
                                    ),

                                    AnimatedSlide(
                                        offset: practiceStatus == PracticeStatusEnum.start ? const Offset(0, 1) : Offset.zero,
                                        duration: const Duration(milliseconds: 700),
                                        curve: Curves.fastOutSlowIn,
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: PracticeStartButton(handleStart: handleStartPractice) // 👈 PRACTICE BOTTOM START BUTTON
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }


}







