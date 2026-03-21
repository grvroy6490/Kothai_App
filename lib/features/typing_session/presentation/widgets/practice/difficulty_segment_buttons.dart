import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
// import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';

class DifficultySegmentButtons extends ConsumerWidget {

    Color? bgColor;
    String? title;

    DifficultySegmentButtons({super.key, this.bgColor, this.title});

    @override
    Widget build(BuildContext context, ref) {
        // 📃 DECLARATION ----------------------------
        // 🌐 PROVIDERS ------------------------------
        final selectedDifficulty = ref.watch(practiceConfigurationProvider).difficulty;
        // final themeMode = ref.watch(themeProvider);

        // 🚀 METHODS --------------------------------
        // 👇 UPDATE DIFFICULTY
        void updateDifficulty(DifficultyEnum d) async {
            await ref.read(practiceConfigurationProvider.notifier).setDifficulty(d);
            ref.read(textContentControllerProvider.notifier).rollNewContent();
        }

        // ⭐ Widget ---------------------------------
        return Container(
            padding: EdgeInsets.only(
                left: Gap(context).gap(10),
                right: Gap(context).gap(5),
                top: Gap(context).gap(3),
                bottom: Gap(context).gap(3)
            ),
            decoration: BoxDecoration(
                color: bgColor ?? getFigmaColor(context, 'Schemes/Background'),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                        offset: const Offset(0, 2)
                    )
                ]
            ),
            child: Row(
                children: [
                    Text(
                        title ?? 'Difficulty',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface'),
                            fontWeight: FontWeight.w500
                        )
                    ),
                    SizedBox(width: Gap(context).gap(5)),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: getFigmaColor(context, 'State Layers/On Background/Opacity-08')
                            ),
                            child: Row(
                                children: DifficultyEnum.values.map((difficulty)  {
                                        final isActive = selectedDifficulty == difficulty;
                                        return Expanded(
                                            child: ElevatedButton(
                                                onPressed: () => updateDifficulty(difficulty),
                                                style: ButtonStyle(
                                                    elevation: WidgetStateProperty.all(
                                                        isActive ? 3 : 0
                                                    ),
                                                    backgroundColor: WidgetStateProperty.all(
                                                        isActive
                                                            ? getFigmaColor(
                                                                context,
                                                                'Schemes/On Background'
                                                            )
                                                            : Colors.transparent
                                                    ),
                                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                                                            horizontal: Gap(context).gap(5),
                                                            vertical: Gap(context).gap(20)
                                                        )),
                                                    minimumSize: WidgetStateProperty.all(Size.zero),
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    visualDensity: VisualDensity.compact,
                                                    shape: WidgetStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(24)
                                                        )
                                                    )

                                                ),
                                                child: Text('${difficulty.name[0].toUpperCase()}${difficulty.name.substring(1).toLowerCase()}',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: isActive ?  getFigmaColor(context, 'Schemes/Background') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                    )
                                                )
                                            )
                                        );
                                    }).toList()
                            )
                        )
                    )
                ]
            )
        );
    }
}