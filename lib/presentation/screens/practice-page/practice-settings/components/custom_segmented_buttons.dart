import 'package:flutter/material.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class CustomSegmentedButtons<T> extends StatelessWidget {
    const CustomSegmentedButtons({
        super.key,
        required this.items,
        required this.selected,
        required this.onChanged,
        required this.labelBuilder,
        this.isSelected,              // optional custom selection logic
        this.spacing = 8,
        this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        this.radius = 30,
        this.activeRadius = 24,
        this.activeBgColor,
        this.inactiveBgColor = Colors.transparent,
        this.activePadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        this.inactivePadding = const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        this.textStyle,
        this.activeTextColor,
        this.inactiveTextColor,
        this.elevationWhenActive = 3,
    });

    final List<T> items;
    final T? selected;
    final ValueChanged<T> onChanged;
    final String Function(T item) labelBuilder;

    final bool Function(T item)? isSelected;

    final double spacing;
    final EdgeInsets padding;
    final double radius;

    final double activeRadius;
    final Color? activeBgColor;
    final Color inactiveBgColor;
    final EdgeInsets activePadding;
    final EdgeInsets inactivePadding;
    final TextStyle? textStyle;
    final Color? activeTextColor;
    final Color? inactiveTextColor;
    final double elevationWhenActive;

    bool _defaultIsSelected(T item) => selected != null && item == selected;

    @override
    Widget build(BuildContext context) {

        return Container(
            padding: padding,
            decoration: BoxDecoration(
                // use your getFigmaColor(...) here if you like
                color: getFigmaColor(context, 'State Layers/On Background/Opacity-08'),
                borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    for (var i = 0; i < items.length; i++) ...[
                            if (i != 0) SizedBox(width: spacing),
                            _SegmentItem<T>(
                                item: items[i],
                                isActive: (isSelected ?? _defaultIsSelected)(items[i]),
                                onPressed: onChanged,
                                labelBuilder: labelBuilder,
                                radius: radius,
                                activeRadius: activeRadius,
                                elevationWhenActive: elevationWhenActive,
                                activeBgColor: activeBgColor ?? getFigmaColor(context, 'Schemes/Surface'),
                                inactiveBgColor: inactiveBgColor,
                                activePadding: activePadding,
                                inactivePadding: inactivePadding,
                                textStyle: textStyle ?? AppTypography.bodyMedium,
                                activeTextColor: activeTextColor ?? getFigmaColor(context, 'Schemes/On Surface Variant'),
                                inactiveTextColor: inactiveTextColor ?? getFigmaColor(context, 'Schemes/On Surface Variant'),
                            ),
                        ],
                ],
            ),
        );
    }
}

class _SegmentItem<T> extends StatelessWidget {
    const _SegmentItem({
        required this.item,
        required this.isActive,
        required this.onPressed,
        required this.labelBuilder,
        required this.radius,
        required this.elevationWhenActive,
        required this.activeBgColor,
        required this.inactiveBgColor,
        required this.activePadding,
        required this.inactivePadding,
        required this.textStyle,
        required this.activeTextColor,
        required this.inactiveTextColor,
        required this.activeRadius,
    });

    final T item;
    final bool isActive;
    final ValueChanged<T> onPressed;
    final String Function(T) labelBuilder;
    final double radius;
    final double elevationWhenActive;
    final Color activeBgColor;
    final Color inactiveBgColor;
    final EdgeInsets activePadding;
    final EdgeInsets inactivePadding;
    final TextStyle textStyle;
    final Color activeTextColor;
    final Color inactiveTextColor;
    final double activeRadius;

    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            onPressed: () => onPressed(item),
            style: ButtonStyle(
                elevation: WidgetStateProperty.all(isActive ? elevationWhenActive : 0),
                backgroundColor: WidgetStateProperty.all(isActive ? activeBgColor : inactiveBgColor),
                padding: WidgetStateProperty.all(isActive ? activePadding : inactivePadding),
                minimumSize: WidgetStateProperty.all(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(activeRadius - 6)),
                ),
            ),
            child: Text(
                labelBuilder(item),
                style: textStyle.copyWith(color: isActive ? activeTextColor : inactiveTextColor, fontWeight: FontWeight.w500),
            ),
        );
    }
}
