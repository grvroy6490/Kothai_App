import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/randomize/practice_randomize_page.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/settings/practice_settings_page.dart';

class PracticeSettingButtons extends ConsumerWidget {
    const PracticeSettingButtons({super.key});

    @override
    Widget build(BuildContext context, ref) {
        // 🌐 PROVIDERS ------------------------------
        // final themeMode = ref.watch(themeProvider);
        final themeMode = ref.watch(themeProvider);
        final isDarkMode = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        // ⭐ Widget ---------------------------------
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Flexible(
                    child: _customIconButton(
                        context,
                        ImageFiltered(
                            imageFilter: ColorFilter.linearToSrgbGamma(),
                            child: SvgPicture.asset(
                                'assets/images/dice.svg',
                                width: Gap(context).gap(18),
                                colorFilter: isDarkMode ? ColorFilter.mode(Colors.white, BlendMode.srcIn) : ColorFilter.mode(Colors.black45, BlendMode.srcIn)
                            )

                        ),
                        () {
                            Get.to(() => PracticeRandomizePage(),
                                transition: Transition.fadeIn,
                                duration: Duration(milliseconds: 600),
                                curve: Curves.easeInOut
                            );
                        },
                        Gap(context).gap(12)
                    )
                ),
                SizedBox(width: 5),
                Flexible(
                    child: _customIconButton(
                        context,
                        Icon(Icons.keyboard_arrow_up, size: Gap(context).gap(16)),
                        () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: getFigmaColor(context, 'Schemes/Background'),       // optional
                                shape: const RoundedRectangleBorder( // optional
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                                ),
                                builder: (context) {
                                    return FractionallySizedBox(       // or SizedBox(height: MediaQuery.of(context).size.height * 0.8)
                                        heightFactor: 0.9,               // 80% of screen
                                        child: Padding(                   // keeps content above keyboard if needed
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom
                                            ),
                                            child: PracticeSettingsPage()
                                        )
                                    );
                                }
                            );
                        },
                        Gap(context).gap(13)
                    )
                )
            ]
        );
    }

    Widget _customIconButton(BuildContext context, Widget icon, VoidCallback handlePress, double padding){
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
                            width: Gap(context).gap(1.5)
                        )
                    )
                )
            ),
            icon: icon
        );
    }
}