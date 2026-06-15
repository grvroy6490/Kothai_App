import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/domain/entities/content/text_paragraph.dart';
import 'package:visai/enums/difficulty/DifficultyEnum.dart';
import 'package:visai/presentation/providers/content/text_provider.dart';
import 'package:visai/presentation/providers/practice/practice_configuration_provider.dart';
import 'package:visai/presentation/providers/practice/prcatice_settings_visibility_provider.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';
import 'package:visai/presentation/theme/theme_manager.dart';

class PracticeSettingsWidget extends ConsumerStatefulWidget {
    const PracticeSettingsWidget({super.key});

    @override
    ConsumerState<PracticeSettingsWidget> createState() =>
    _PracticeSettingsWidgetState();
}

class _PracticeSettingsWidgetState extends ConsumerState<PracticeSettingsWidget> {

    late DifficultyEnum _selected;

    @override
    void initState(){
        super.initState();
        // Initialize from the current state of the notifier-backed provider
        _selected = ref.read(practiceConfigurationProvider).difficulty;
    }

    @override
    Widget build(BuildContext context) {

        ref.listen<DifficultyEnum>(practiceConfigurationProvider.select((s) => s.difficulty), (prev, next) {
                if (mounted) {
                    setState(() { _selected = next; });
                }
            });

        final bgColor = getFigmaColor(context, 'Schemes/Background');
        final onSurfaceVariant = getFigmaColor(context, 'Schemes/On Surface Variant',);

        return Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10,
                            right: 5,
                            top: 3,
                            bottom: 3,
                        ),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                ),
                            ],
                        ),
                        child: Row(
                            children: [
                                Text(
                                    'Difficulty',
                                    style: AppTypography.bodySmall.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface'),
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                                const SizedBox(width: 7),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(
                                            context,
                                            'State Layers/On Background/Opacity-08',
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                        spacing: 0,
                                        children: DifficultyEnum.values.map((difficulty) {
                                                final isActive = _selected == difficulty;
                                                return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: ElevatedButton(
                                                        onPressed: () => {
                                                            ref.read(practiceConfigurationProvider.notifier).setDifficulty(difficulty)
                                                        },
                                                        style: ButtonStyle(
                                                            elevation: WidgetStateProperty.all(
                                                                isActive ? 3 : 0,
                                                            ),
                                                            backgroundColor: WidgetStateProperty.all(
                                                                isActive
                                                                    ? getFigmaColor(
                                                                        context,
                                                                        'Schemes/On Background',
                                                                    )
                                                                    : Colors.transparent,
                                                            ),
                                                            padding: WidgetStateProperty.all(
                                                                isActive
                                                                    ? const EdgeInsets.symmetric(
                                                                        horizontal: 10,
                                                                        vertical: 15,
                                                                    )
                                                                    : const EdgeInsets.symmetric(
                                                                        horizontal: 5,
                                                                        vertical: 5,
                                                                    ),
                                                            ),
                                                            minimumSize: WidgetStateProperty.all(Size.zero),
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            visualDensity: VisualDensity.compact,
                                                            shape: WidgetStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(24),
                                                                ),
                                                            ),
                                                        ),
                                                        child: Text(
                                                            '${difficulty.name[0].toUpperCase()}${difficulty.name.substring(1).toLowerCase()}',
                                                            style: AppTypography.bodySmall.copyWith(
                                                                color: isActive ? bgColor : onSurfaceVariant,
                                                                fontWeight: FontWeight.w500,
                                                            ),
                                                        ),
                                                    ),
                                                );
                                            }).toList(),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    SizedBox(width: 3,),
                    // RONDOMIZE AND SETTINGS BUTTON
                    _customIconButton(
                        SvgPicture.asset('assets/images/dice.svg', width: 18,),
                        () async {
                            var newContent = await ref.watch(textRepositoryProvider).getPreloadedTexts();
                            ref.read(textContentProvider.notifier).setTextContent(newContent[0]);
                        },

                        12
                    ),
                    _customIconButton(
                        Icon(Icons.keyboard_arrow_up, size: 16,),
                        () {
                            ref.read(practiceSettingsVisibilityProvider.notifier).showSettings();
                        },
                        13
                    )
                ],
            ),
        );
    }

    // CUSTOM ICON BUTTON
    Widget _customIconButton(Widget icon, VoidCallback handlePress, double padding){
        return IconButton(
            onPressed: handlePress,
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                ),
                padding: WidgetStateProperty.all(EdgeInsets.all(padding)),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                            color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                            width: 1.5,
                        ),
                    ),
                ),
            ),
            icon: icon,
        );
    }
}
