
import 'package:flutter/material.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

Widget switchButton(context, switchValue, onChanged){
    return Switch(
        value: switchValue,
        padding: EdgeInsets.zero,
        inactiveTrackColor: getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-16'),
        inactiveThumbColor: getFigmaColor(context, 'Schemes/On Surface Variant').withAlpha(127),
        activeTrackColor: getFigmaColor(context, 'Schemes/On Surface Variant'),
        activeThumbColor: getFigmaColor(context, 'Schemes/Surface'),
        trackOutlineColor: WidgetStateProperty.all(getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-04')),
        onChanged: (val) => onChanged(val)
    );
}