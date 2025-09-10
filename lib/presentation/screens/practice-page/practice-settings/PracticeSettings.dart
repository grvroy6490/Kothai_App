import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';
import 'package:kothai_app/enums/ModeEnum.dart';
import 'package:kothai_app/presentation/providers/practice/practice_configuration_provider.dart';
import 'package:kothai_app/presentation/providers/practice/prcatice_settings_visibility_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/practice-settings/components/custom_segmented_buttons.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class PracticeSettings extends ConsumerStatefulWidget {
    const PracticeSettings({super.key});

    @override
    ConsumerState<PracticeSettings> createState() => _PracticeSettingsState();
}

class _PracticeSettingsState extends ConsumerState<PracticeSettings> {
    late DifficultyEnum _selectedDifficulty;
    late PracticeMode _selectedMode;

    @override
    void initState() {
        super.initState();
        _selectedDifficulty = ref.read(practiceConfigurationProvider).difficulty;
        _selectedMode = ref.read(practiceConfigurationProvider).mode;
    }

    @override
    Widget build(BuildContext ctx) {
        // Difficulty
        ref.listen<DifficultyEnum>( practiceConfigurationProvider.select((s) => s.difficulty), (prev, next) {
                if (mounted) {
                    setState(() => _selectedDifficulty = next);
                }
            },
        );

        // Mode
        ref.listen<PracticeMode>( practiceConfigurationProvider.select((s) => s.mode), (prev, next) {
                if (mounted) {
                    setState(() => _selectedMode = next);
                }
            },
        );

        final bgColor = getFigmaColor(context, 'Schemes/Background');
        final onSurfaceVariant = getFigmaColor(
            context,
            'Schemes/On Surface Variant',
        );

        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                ),
                color: getFigmaColor(context, 'Schemes/Background'),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    _titleBar(ctx, ref),

                    // SET DIFFICULTY
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: getFigmaColor(
                                        context,
                                        'State Layers/Outline/Opacity-16',
                                    ),
                                    width: 1,
                                ),
                            ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Difficulty',
                                    style: AppTypography.bodyMedium.copyWith(
                                        color: onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                                const SizedBox(width: 7),
                                CustomSegmentedButtons<DifficultyEnum>(
                                    items: DifficultyEnum.values,
                                    selected: _selectedDifficulty,
                                    onChanged: (d) {
                                        ref.read(practiceConfigurationProvider.notifier).setDifficulty(d);
                                    },
                                    labelBuilder: (d) =>
                                    '${d.name[0].toUpperCase()}${d.name.substring(1).toLowerCase()}',
                                    radius: 10,
                                    activeRadius: 14,
                                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                    activePadding: EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 18,
                                    ),
                                    inactivePadding: EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 18,
                                    ),
                                    elevationWhenActive: 2,
                                    spacing: 0,
                                ),

                            ],
                        ),
                    ),

                    // SET PRACTICE MODE
                    Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(
                                            'Mode',
                                            style: AppTypography.bodyMedium.copyWith(
                                                color: onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                            ),
                                        ),
                                        const SizedBox(width: 7),
                                        CustomSegmentedButtons<PracticeMode>(
                                            items: PracticeMode.values,
                                            selected: _selectedMode,
                                            onChanged: (m) {
                                                ref.read(practiceConfigurationProvider.notifier).setMode(m);
                                            },
                                            labelBuilder: (m) =>
                                            '${m.name[0].toUpperCase()}${m.name.substring(1).toLowerCase()}',
                                            radius: 10,
                                            activeRadius: 14,
                                            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                            activePadding: EdgeInsets.symmetric(
                                                horizontal: 22,
                                                vertical: 18,
                                            ),
                                            inactivePadding: EdgeInsets.symmetric(
                                                horizontal: 22,
                                                vertical: 18,
                                            ),
                                            elevationWhenActive: 2,
                                            spacing: 0,
                                        ),
                                    ],
                                ),
                                SizedBox(height: 5),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        'Only play at 100% accuracy (Stop on a Error)',
                                        style: AppTypography.bodySmall.copyWith(
                                            color: getFigmaColor(
                                                context,
                                                'State Layers/On Background/Opacity-60',
                                            ),
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),

                    // SET BLIND MODE
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: getFigmaColor(
                                        context,
                                        'State Layers/Outline/Opacity-16',
                                    ),
                                    width: 1,
                                ),
                            ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: getFigmaColor(
                                    context,
                                    'State Layers/On Background/Opacity-08',
                                ),
                                borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Icon(
                                        Icons.visibility_off,
                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                        size: 20,
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    'Blind Mode',
                                                    style: AppTypography.labelLarge.copyWith(
                                                        color: getFigmaColor(
                                                            context,
                                                            'Schemes/On Surface Variant',
                                                        ),
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                ),
                                                FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                        'No errors or incorrect words are highlighted.',
                                                        style: AppTypography.bodySmall.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface Variant',
                                                            ),
                                                            fontWeight: FontWeight.w500,
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                    SizedBox(width: 10,),
                                    Switch(
                                        value: false,
                                        padding: EdgeInsets.zero,
                                        inactiveTrackColor: getFigmaColor(
                                            context,
                                            'State Layers/On Surface Variant/Opacity-16',
                                        ),
                                        inactiveThumbColor: getFigmaColor(
                                            context,
                                            'Schemes/On Surface Variant',
                                        ),
                                        activeTrackColor: getFigmaColor(
                                            context,
                                            'Schemes/On Surface Variant',
                                        ),
                                        activeThumbColor: getFigmaColor(context, 'Schemes/Surface'),

                                        trackOutlineColor: WidgetStateProperty.all(
                                            getFigmaColor(
                                                context,
                                                'State Layers/On Surface Variant/Opacity-04',
                                            ),
                                        ),
                                        onChanged: (val) {},
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}

Widget _titleBar(ctx, WidgetRef ref) {
    return Container(
        color: getFigmaColor(ctx, 'State Layers/On Background/Opacity-08'),
        padding: EdgeInsets.only(left: 16, right: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Row(
                    children: [
                        Icon(
                            FontAwesomeIcons.gear,
                            color: getFigmaColor(ctx, 'Schemes/On Surface'),
                            size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                            'Test Settings',
                            style: AppTypography.bodyMedium.copyWith(
                                color: getFigmaColor(ctx, 'Schemes/On Surface'),
                            ),
                        ),
                    ],
                ),

                IconButton(
                    onPressed: () {
                        ref.read(practiceSettingsVisibilityProvider.notifier).hideSetting();
                    },
                    icon: Icon(
                        FontAwesomeIcons.chevronDown,
                        color: getFigmaColor(ctx, 'Schemes/On Surface'),
                        size: 14,
                    ),
                ),
            ],
        ),
    );
}
