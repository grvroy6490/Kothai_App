import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/providers/practice/prcatice_settings_visibility_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/practice-settings/PracticeSettings.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/EditorArea.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/PracticeHeader.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:kothai_app/presentation/shared/footer_navigation_bar.dart';
import 'package:kothai_app/presentation/shared/bottom_slide_modal.dart';

class PracticePage extends ConsumerStatefulWidget {
    final TextEditingController controller;
    final FocusNode focusNode;
    const PracticePage({super.key, required this.controller, required this.focusNode});

    @override
    ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
    final int _currentIndex = 0;
    bool _settingsModalOpen = false;

    void _openSettingsModal() {
        _settingsModalOpen = true;
        BottomSlideModal.show(
            context: context,
            child: SizedBox(width: double.infinity, child: PracticeSettings()),
        ).whenComplete(() {
                    _settingsModalOpen = false;
                    // keep provider in sync if user swipes to dismiss
                    final notifier = ref.read(practiceSettingsVisibilityProvider.notifier);
                    if (notifier.mounted) notifier.hideSetting();
                });
    }

    @override
    Widget build(BuildContext context) {


        // listen in build (allowed)
        ref.listen<bool>(practiceSettingsVisibilityProvider, (prev, next) {
                if (next && !_settingsModalOpen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            _openSettingsModal();
                        });
                }
                if (!next && _settingsModalOpen) {
                    // close programmatically if your modal supports it; fallback:
                    Navigator.of(context).maybePop();
                }
            });

        final practiceStatus = ref.watch(practiceStatusProvider);


        return Scaffold(
            bottomNavigationBar: FooterNavigationBar(
                currentIndex: _currentIndex,
                practiceStatus: practiceStatus,
            ),
            body: Stack(
                children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuad,
                        color: practiceStatus == PracticeStatus.start
                            ? getFigmaColor(context, 'Schemes/Surface Container')
                            : getFigmaColor(context, 'Schemes/Background'),
                        child: SafeArea(
                            top: false,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: PracticeHeader(),
                                    ),
                                    Expanded(child: EditorArea(focusNode: widget.focusNode, controller: widget.controller,)),
                                ],
                            ),
                        ),
                    ),


                ],
            ),
        );
    }
}
