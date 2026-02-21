import 'package:flutter/material.dart';
import 'package:visai/core/theme/figma_color.dart';

Future<T?> showAppModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    double heightFactor = 0.5,
    bool isScrollControlled = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool useRootNavigator = true
}) {
    final bg = backgroundColor ?? getFigmaColor(context, 'Schemes/Background');
    final shp = shape ?? const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
        );

    return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        backgroundColor: bg,
        shape: shp,
        builder: (ctx) => FractionallySizedBox(
            heightFactor: heightFactor,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom
                ),
                child: Builder(builder: builder)
            )
        )
    );
}

Future<T?> showAppModalWithChild<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.5,
    bool isScrollControlled = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool useRootNavigator = true
}) {
    return showAppModalBottomSheet<T>(
        context: context,
        builder: (_) => child,
        heightFactor: heightFactor,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        shape: shape,
        useRootNavigator: useRootNavigator
    );
}
