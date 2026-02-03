
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/badges/data/model/badge_entity.dart';

class BadgePage extends StatefulWidget {
    final BadgeEntity badge;
    const BadgePage({super.key , required this.badge});

    @override
    State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: [
                        Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                'assets/images/Pattern.png',
                                width: double.infinity,
                                height: double.infinity
                            )
                        ),

                        SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Stack(
                                                children: [
                                                    Positioned(
                                                        left: 0,
                                                        bottom: 0,
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Container(
                                                                constraints: BoxConstraints(
                                                                    minWidth:
                                                                    MediaQuery.of(context).size.width - 32
                                                                ),
                                                                height: Gap(context).gap(270),
                                                                padding: EdgeInsets.all(Gap(context).gap(16)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'State Layers/Secondary/Opacity-10'
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),

                                                    Padding(
                                                        padding: EdgeInsets.all(Gap(context).gap(16)),
                                                        child: Column(
                                                            children: [
                                                                Container(
                                                                    padding: EdgeInsets.all(Gap(context).gap(20)),
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin: Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                                getFigmaColor(
                                                                                    context,
                                                                                    'Palettes/Secondary 95'
                                                                                ),
                                                                                getFigmaColor(
                                                                                    context,
                                                                                    'Palettes/Secondary 80'
                                                                                )
                                                                            ]),
                                                                        borderRadius: BorderRadius.circular(100)
                                                                    ),
                                                                    child: Image.asset(
                                                                        widget.badge.imagePath,
                                                                        width: Gap(context).gap(70),
                                                                        height: Gap(context).gap(70)
                                                                    )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(30)),
                                                                Text(
                                                                    'New Badge Unlocked!',
                                                                    style: Theme.of(context).textTheme.titleLarge
                                                                        ?.copyWith(
                                                                            color: getFigmaColor(
                                                                                context,
                                                                                'Schemes/Secondary'
                                                                            ),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(10)),
                                                                Text(
                                                                    '(${widget.badge.name})',
                                                                    style: Theme.of(context).textTheme.titleMedium
                                                                        ?.copyWith(
                                                                            color: getFigmaColor(
                                                                                context,
                                                                                'Schemes/On Surface Variant'
                                                                            ),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(10)),
                                                                SizedBox(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.8,
                                                                    child: Center(
                                                                        child: Text(
                                                                            widget.badge.condition,
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodyLarge
                                                                                ?.copyWith(
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'Schemes/On Surface'
                                                                                    )
                                                                                ),
                                                                            textAlign: TextAlign.center
                                                                        )
                                                                    )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(20)),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    spacing: Gap(context).gap(16),
                                                                    children: [
                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    padding: WidgetStateProperty.all(
                                                                                        EdgeInsets.symmetric(
                                                                                            horizontal: 0,
                                                                                            vertical: Gap(context).gap(16)
                                                                                        )
                                                                                    ),
                                                                                    backgroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Secondary'
                                                                                        )
                                                                                    ),
                                                                                    foregroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/Secondary'
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                onPressed: () => Navigator.of(context).pop(),
                                                                                child: Text(
                                                                                    'Close',
                                                                                    style: Theme.of(context)
                                                                                        .textTheme
                                                                                        .bodyLarge
                                                                                        ?.copyWith(
                                                                                            color: getFigmaColor(
                                                                                                context,
                                                                                                'Schemes/Secondary'
                                                                                            )
                                                                                        )
                                                                                )
                                                                            )
                                                                        )

                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}
