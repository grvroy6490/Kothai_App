
import 'package:flutter/material.dart';
import 'package:kothai_app/features/badges/data/model/badge_entity.dart';
import 'package:kothai_app/features/badges/presentation/pages/badge_page.dart';

void showBadgePopup(BuildContext context, BadgeEntity badge) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
            return BadgePage(badge: badge);
        }
    );
}