
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

Widget segmentedButtons<T extends Enum>(
    context,
    T selected,
    List<T> iterable,
    void Function(T) onSelected
){
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: getFigmaColor(context, 'State Layers/On Background/Opacity-08')
        ),
        padding: EdgeInsets.all(Gap(context).gap(3)),
        child: Row(
            children: iterable.map((property)  {
                    final isActive = selected == property;

                    return Expanded(
                        child: ElevatedButton(
                            onPressed: () => onSelected(property),
                            style: ButtonStyle(
                                elevation: WidgetStateProperty.all(
                                    isActive ? 3 : 0
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                    isActive
                                        ? getFigmaColor(
                                            context,
                                            'Schemes/Surface'
                                        )
                                        : Colors.transparent
                                ),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: Gap(context).gap(10),
                                        vertical: Gap(context).gap(20)
                                    )
                                ),
                                minimumSize: WidgetStateProperty.all(Size.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                )

                            ),
                            child: Text('${property.name[0].toUpperCase()}${property.name.substring(1).toLowerCase()}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isActive ? getFigmaColor(context, 'Schemes/On Surface Variant') : getFigmaColor(context, 'Schemes/On Surface Variant').withAlpha(127)
                                )
                            )
                        )
                    );
                }).toList()
        )
    );

}