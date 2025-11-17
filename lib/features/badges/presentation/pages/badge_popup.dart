
import 'package:flutter/material.dart';
import 'package:kothai_app/features/badges/data/model/badge_entity.dart';

void showBadgePopup(BuildContext context, BadgeEntity badge) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
            return Dialog(
                backgroundColor: Colors.transparent,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Image.asset(badge.imagePath, width: 140),
                        const SizedBox(height: 12),
                        Text(
                            "Badge Unlocked!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white
                            )
                        ),
                        const SizedBox(height: 8),
                        Text(
                            badge.name,
                            style: const TextStyle(fontSize: 16, color: Colors.white70)
                        )
                    ]
                )
            );
        }
    );
}