import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/di/providers/navigation/navigation_provider.dart';
import 'package:visai/features/more/presentation/pages/achievement/achievement_gallery_page.dart';
import 'package:visai/features/more/presentation/pages/streak_board/streak_board_page.dart';
import 'package:visai/features/more/presentation/pages/xp_milestones/xp_milestones_page.dart';

/// Navigate from an in-app notification [routePayload] or local notification payload.
void navigateFromNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) return;

  final context = Get.context;
  if (context == null) {
    _fallbackRoute(payload);
    return;
  }

  final container = ProviderScope.containerOf(context, listen: false);
  final nav = container.read(selectNavProvider.notifier);

  switch (payload) {
    case kNotificationPayloadAchievementGallery:
      Get.to(
        () => const AchievementGalleryPage(),
        transition: Transition.fadeIn,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 400),
      );
      break;
    case kNotificationPayloadStreakBoard:
      Get.to(
        () => const StreakBoardPage(),
        transition: Transition.fadeIn,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 400),
      );
      break;
    case kNotificationPayloadXpMilestones:
      Get.to(
        () => const XpMilestonesPage(),
        transition: Transition.fadeIn,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 400),
      );
      break;
    case kNotificationPayloadPractice:
    default:
      nav.set(0);
      if (Get.currentRoute != '/practice') {
        Get.offNamed('/practice');
      }
      break;
  }
}

void _fallbackRoute(String payload) {
  switch (payload) {
    case kNotificationPayloadPractice:
      Get.offNamed('/practice');
      break;
    default:
      Get.offNamed('/practice');
  }
}
