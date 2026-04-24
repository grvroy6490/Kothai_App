import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/notifications/domain/in_app_notification.dart';
import 'package:visai/features/notifications/presentation/riverpod/in_app_notifications_controller.dart';

/// Opens a modal bottom sheet with the in-app notification list.
Future<void> showInAppNotificationsPanel(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _InAppNotificationsSheet(),
  );
}

class _InAppNotificationsSheet extends ConsumerWidget {
  const _InAppNotificationsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inAppNotificationsControllerProvider);
    final notifier = ref.read(inAppNotificationsControllerProvider.notifier);

    final h = MediaQuery.sizeOf(context).height * 0.72;

    return Container(
      height: h,
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Schemes/Surface Container High'),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: getFigmaColor(context, 'Schemes/On Surface'),
                      ),
                ),
                const Spacer(),
                if (items.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await notifier.markAllRead();
                    },
                    child: Text(
                      'Mark all read',
                      style: TextStyle(
                        color: getFigmaColor(context, 'Schemes/Primary'),
                        fontSize: KxScale(context).sp(13),
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: getFigmaColor(
              context,
              'State Layers/On Surface Variant/Opacity-08',
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No notifications yet.\nBadge unlocks and session summaries will appear here.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: getFigmaColor(
                                context,
                                'Schemes/On Surface Variant',
                              ),
                            ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final n = items[index];
                      return _NotificationTile(
                        notification: n,
                        onTap: () async {
                          await notifier.markRead(n.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final InAppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final d = notification.createdAt;
    final timeStr =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    final unread = !notification.read;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unread
                      ? getFigmaColor(context, 'Schemes/Primary')
                      : Colors.transparent,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight:
                                unread ? FontWeight.w700 : FontWeight.w500,
                            color: getFigmaColor(
                              context,
                              'Schemes/On Surface',
                            ),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: getFigmaColor(
                              context,
                              'Schemes/On Surface Variant',
                            ),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: getFigmaColor(
                              context,
                              'Schemes/On Surface Variant',
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
