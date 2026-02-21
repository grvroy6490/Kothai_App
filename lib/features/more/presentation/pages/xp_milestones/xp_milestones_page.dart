import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/score/score_repo_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/features/user_profile/presentation/widgets/stats_card.dart';
import 'package:visai/features/user_profile/presentation/widgets/user_badge_gallery.dart';
import 'package:visai/presentation/shared/app_bar_compact.dart';

class XpMilestonesPage extends ConsumerStatefulWidget {
    const XpMilestonesPage({super.key});

    @override
    ConsumerState<XpMilestonesPage> createState() => _XpMilestonesPageState();
}

class _XpMilestonesPageState extends ConsumerState<XpMilestonesPage> {
    @override
    Widget build(BuildContext context) {
        final badges = ref.read(badgeControllerProvider);
        final score = ref.watch(scoreControllerProvider);

        // Calculate progress to next level
        final nextLevel = score.level + 1;
        final currentLevelStartXp = score.xpNextLevel - score.xpIntoLevel;
        final xpEarnedInCurrentLevel = score.totalXp - currentLevelStartXp;
        final levelProgress = score.xpIntoLevel == 0
            ? 0.0
            : (xpEarnedInCurrentLevel / score.xpIntoLevel).clamp(0.0, 1.0);
        final levelProgressPercentage = (levelProgress * 100).round();

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            appBar: AppBarCompact(leading: true, title: 'XP & Milestones'),
            bottomNavigationBar: BottomNavigationBarWidget(),

            body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                    padding: EdgeInsets.only(
                        top: Gap(context).gap(10),
                        left: Gap(context).gap(10),
                        right: Gap(context).gap(10)
                    ),
                    decoration: BoxDecoration(
                        color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                    ),
                    child: Column(
                        children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gap(context).gap(15),
                                    vertical: Gap(context).gap(10)
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: getFigmaColor(
                                        context,
                                        'Schemes/Surface Container Lowest'
                                    )
                                ),

                                child: Column(
                                    children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Gap(context).gap(10),
                                                vertical: Gap(context).gap(5)
                                            ),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                        getFigmaColor(context, 'Palettes/Secondary 90'),
                                                        getFigmaColor(context, 'Palettes/Primary 80')
                                                    ]
                                                )
                                            ),
                                            child: Row(
                                                children: [
                                                    SvgPicture.asset(
                                                        'assets/images/Gold_Icon.svg',
                                                        width: Gap(context).gap(24)
                                                    ),
                                                    SizedBox(width: Gap(context).gap(10)),
                                                    Text(
                                                        'Level ${score.level}',
                                                        style: Theme.of(context).textTheme.titleLarge
                                                            ?.copyWith(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/Primary'
                                                                )
                                                            )
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(15)),

                                        Container(
                                            width: double.infinity,

                                            child: Row(
                                                children: [
                                                    Expanded(
                                                        child: Column(
                                                            children: [
                                                                Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: 2
                                                                            ),
                                                                            child: Text(
                                                                                'Progress to Level $nextLevel',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Surface'
                                                                                        )
                                                                                    )
                                                                            )
                                                                        ),

                                                                        Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: 2
                                                                            ),
                                                                            child: Text(
                                                                                '$levelProgressPercentage%',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Surface'
                                                                                        )
                                                                                    )
                                                                            )
                                                                        )
                                                                    ]
                                                                ),

                                                                SizedBox(height: Gap(context).gap(8)),
                                                                Stack(
                                                                    children: [
                                                                        // Background progress bar
                                                                        Container(
                                                                            width: double.infinity,
                                                                            height: Gap(context).gap(8),
                                                                            decoration: BoxDecoration(
                                                                                color: getFigmaColor(
                                                                                    context,
                                                                                    'State Layers/On Surface/Opacity-08'
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(25)
                                                                            )
                                                                        ),
                                                                        // Progress fill
                                                                        Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: FractionallySizedBox(
                                                                                widthFactor: levelProgress,
                                                                                child: Container(
                                                                                    height: Gap(context).gap(8),
                                                                                    decoration: BoxDecoration(
                                                                                        gradient: LinearGradient(
                                                                                            begin: Alignment.topLeft,
                                                                                            end: Alignment.bottomRight,
                                                                                            colors: [
                                                                                                getFigmaColor(
                                                                                                    context,
                                                                                                    'Palettes/Secondary 90'
                                                                                                ),
                                                                                                getFigmaColor(
                                                                                                    context,
                                                                                                    'Palettes/Primary 80'
                                                                                                )
                                                                                            ]
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(
                                                                                            25
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                ),
                                                                SizedBox(height: Gap(context).gap(8)),

                                                                Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: 2
                                                                            ),
                                                                            child: Text(
                                                                                '$xpEarnedInCurrentLevel XP',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Surface'
                                                                                        )
                                                                                    )
                                                                            )
                                                                        ),

                                                                        Text(
                                                                            '${score.xpIntoLevel} XP',
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodySmall
                                                                                ?.copyWith(
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'Schemes/On Surface'
                                                                                    )
                                                                                )
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                    ),
                                                    SizedBox(width: Gap(context).gap(10)),
                                                    _PentagonBadge(number: nextLevel.toString())
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(15)),

                                        FutureBuilder<List<ScoreEntry>>(
                                            future: ref
                                                .read(scoreLocalRepositoryProvider)
                                                .listEntriesFromDB(),
                                            builder: (context, snapshot) {
                                                int todayXp = 0;
                                                int weeklyXp = 0;

                                                if (snapshot.hasData) {
                                                    final entries = snapshot.data!;
                                                    final now = DateTime.now();
                                                    final todayStart = DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day
                                                    );
                                                    final weekStart = todayStart.subtract(
                                                        const Duration(days: 6)
                                                    );

                                                    for (final entry in entries) {
                                                        final entryDate = entry.at;
                                                        if (entryDate.isAfter(todayStart) ||
                                                            entryDate.isAtSameMomentAs(todayStart)) {
                                                            todayXp += entry.amount;
                                                        }
                                                        if (entryDate.isAfter(weekStart) ||
                                                            entryDate.isAtSameMomentAs(weekStart)) {
                                                            weeklyXp += entry.amount;
                                                        }
                                                    }
                                                }

                                                return Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(Gap(context).gap(10)),
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(
                                                            context,
                                                            'Schemes/Surface Container'
                                                        ),
                                                        borderRadius: BorderRadius.circular(24)
                                                    ),
                                                    child: Row(
                                                        spacing: 10,
                                                        children: [
                                                            Expanded(
                                                                child: StatCard(
                                                                    value: todayXp.toString(),
                                                                    label: 'Today\'s XP',
                                                                    icon: Icons.today,
                                                                    iconSize: 24,
                                                                )
                                                            ),
                                                            Expanded(
                                                                child: StatCard(
                                                                    value: weeklyXp.toString(),
                                                                    label: 'Weekly XP',
                                                                    icon: Icons.date_range,
                                                                    iconSize: 24,
                                                                )
                                                            )
                                                        ]
                                                    )
                                                );
                                            }
                                        )
                                    ]
                                )
                            ),

                            SizedBox(height: Gap(context).gap(15)),

                            UserBadgeGallery(badges: badges),

                            SizedBox(height: Gap(context).gap(10))
                        ]
                    )
                )
            )
        );
    }
}

class _PentagonBadge extends StatelessWidget {
    final String number;

    const _PentagonBadge({required this.number});

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: 100,
            height: 100,
            child: Stack(
                children: [
                    ClipPath(
                        clipper: _PentagonClipper(),
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                        Color(0xFFFFE5D4), // Light peach
                                        Color(0xFFE8D5F0) // Light lavender purple
                                    ]
                                )
                            ),
                            child: Center(
                                child: Text(
                                    number,
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6B46C1) // Dark purple
                                    )
                                )
                            )
                        )
                    ),
                    CustomPaint(painter: _PentagonPainter(), child: Container())
                ]
            )
        );
    }
}

class _PentagonClipper extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
        final path = Path();
        final centerX = size.width / 2;
        final centerY = size.height / 2;
        final radius = size.width / 2.2;

        // Create rounded pentagon
        for (int i = 0; i < 5; i++) {
            final angle = (i * 2 * 3.14159 / 5) - (3.14159 / 2); // Start from top
            final x = centerX + radius * math.cos(angle);
            final y = centerY + radius * math.sin(angle);

            if (i == 0) {
                path.moveTo(x, y);
            } else {
                path.lineTo(x, y);
            }
        }
        path.close();

        return path;
    }

    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _PentagonPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
            ..color = Colors.grey.shade300
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

        final path = Path();
        final centerX = size.width / 2;
        final centerY = size.height / 2;
        final radius = size.width / 2.2;

        // Create pentagon border
        for (int i = 0; i < 5; i++) {
            final angle = (i * 2 * 3.14159 / 5) - (3.14159 / 2); // Start from top
            final x = centerX + radius * math.cos(angle);
            final y = centerY + radius * math.sin(angle);

            if (i == 0) {
                path.moveTo(x, y);
            } else {
                path.lineTo(x, y);
            }
        }
        path.close();

        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => false;
}
