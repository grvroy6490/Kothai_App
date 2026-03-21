import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/difficulty_segment_buttons.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practise_settings_button.dart';

class PracticeStartButton extends StatelessWidget {
  void Function() handleStart;
  PracticeStartButton({super.key, required this.handleStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    MediaQuery.of(context).size.width * 0.5,
                  ),
                  topRight: Radius.circular(
                    MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: Gap(context).gap(280),
                    height: Gap(context).gap(200),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          getFigmaColor(
                            context,
                            'Schemes/Surface Container Lowest',
                          ),
                          getFigmaColor(
                            context,
                            'Schemes/Surface Container',
                          ).withAlpha(0),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          MediaQuery.of(context).size.width * 0.5,
                        ),
                        topRight: Radius.circular(
                          MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Color.fromARGB(255, 220, 195, 122),
                          width: Gap(context).gap(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return GestureDetector(
                        onTap: () => handleStart(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Image.asset(
                                'assets/images/start_icon_purple.png',
                                width: Gap(context).gap(60),
                              ),
                            ),
                            SizedBox(height: Gap(context).gap(5)),
                            Text(
                              'Start Practice',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/Primary',
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // PRACTICE SETTINGS
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(Gap(context).gap(14)),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: DifficultySegmentButtons()),
                          SizedBox(width: Gap(context).gap(10)),
                          Expanded(child: PracticeSettingButtons()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
