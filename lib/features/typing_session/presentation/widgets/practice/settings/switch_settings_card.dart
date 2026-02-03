import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/config_switch_option.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/switch_button.dart';

class SwitchSettingsCard extends StatelessWidget {
    final String cardTitle;
    final List<ConfigSwitchOption> options;
    final PracticeConfig config;
    void Function(PracticeConfig) updateCofiguration;

    SwitchSettingsCard({
        super.key, 
        required this.cardTitle, 
        required this.options, 
        required this.config,
        required this.updateCofiguration
    });

    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
            child: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: getFigmaColor(context, 'State Layers/On Background/Opacity-04'),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: getFigmaColor(context, 'State Layers/On Background/Opacity-08').withAlpha(10),
                                border: Border(
                                    bottom: BorderSide(
                                        color: getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-08'),
                                        width: 1
                                    )
                                )
                            ),
                            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(15), vertical: Gap(context).gap(8)),
                            child: Text(cardTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                )
                            )
                        ),
                        GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,                           // 👈 let it measure to its content
                            physics: const NeverScrollableScrollPhysics(), // 👈 avoid nested scrolling
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 1,
                                // crossAxisSpacing: 1,
                                childAspectRatio: 3.5 // wider cells for your Row(title + switch)
                            ),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                                final opt = options[index];
                                final isOn = opt.select(config);

                                return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gap(context).gap(15),
                                        vertical: Gap(context).gap(6)
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(width: 1, color: getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-08')),
                                            left: (index.isEven) ? BorderSide(width: 1, color: getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-08')) : BorderSide.none,
                                            bottom: BorderSide(width: 1, color: getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-08'))
                                        )
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: Text(
                                                    opt.title,
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: isOn ? getFigmaColor(context, 'Schemes/On Surface Variant') : getFigmaColor(context, 'Schemes/On Surface Variant').withAlpha(127)
                                                    )
                                                )
                                            ),

                                            SizedBox(
                                                child: switchButton(context, isOn, (_) => updateCofiguration(opt.toggle(config)))  // 👈 mutate
                                            )
                                        ]
                                    )
                                );
                            }
                        )

                    ]
                )
            )
        );
    }
}


