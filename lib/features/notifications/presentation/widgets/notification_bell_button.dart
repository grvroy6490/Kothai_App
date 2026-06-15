import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/notifications/presentation/riverpod/in_app_notifications_controller.dart';
import 'package:visai/features/notifications/presentation/widgets/in_app_notifications_sheet.dart';

/// Bell matching existing app bar styling; opens [showInAppNotificationsPanel] and shows unread count.
class NotificationBellIconButton extends ConsumerWidget {
  const NotificationBellIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(inAppNotificationsUnreadCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        IconButton(
          padding: const EdgeInsets.all(11),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          onPressed: () => showInAppNotificationsPanel(context, ref),
          icon: Icon(
            Icons.notifications,
            size: KxScale(context).sp(18),
            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
          ),
        ),
        if (unread > 0)
          Positioned(
            right: 4,
            top: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              alignment: Alignment.center,
              child: Text(
                unread > 99 ? '99+' : '$unread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
