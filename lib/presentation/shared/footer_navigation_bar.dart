import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/enums/PracticeStatusEnum.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterNavigationBar extends StatefulWidget {
    late int currentIndex;
    late PracticeStatus practiceStatus;
    FooterNavigationBar({super.key, required this.currentIndex, required this.practiceStatus});

    @override
    State<FooterNavigationBar> createState() => _FooterNavigationBarState();
}

class _FooterNavigationBarState extends State<FooterNavigationBar> {
    @override
    Widget build(BuildContext ctx) {
        return AnimatedOpacity(
            opacity: widget.practiceStatus == PracticeStatus.start ? 0 : 1,
            curve: Curves.easeInOutQuad,
            duration: Duration(microseconds: 600),
            child: Padding(
                padding: EdgeInsets.only(top: 3),
                child: Theme(
                    data: Theme.of(ctx).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                        iconSize: 20,
                        enableFeedback: false,
                        unselectedLabelStyle: AppTypography.bodySmall.copyWith(
                            color: getFigmaColor(
                                context,
                                'Schemes/On Background',
                            ).withAlpha(153),
                        ),
                        currentIndex: widget.currentIndex,
                        onTap: (index) {
                            setState(() {
                                    widget.currentIndex = index;
                                });
                        },
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: getFigmaColor(ctx, 'Schemes/Surface'),
                        selectedItemColor: getFigmaColor(ctx, 'Schemes/Primary'),
                        unselectedItemColor: getFigmaColor(
                            ctx,
                            'Schemes/On Background',
                        ).withAlpha(153),
                        items: const [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.keyboard),
                                label: 'Practice',
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.emoji_events),
                                label: 'Challenge',
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.account_circle),
                                label: 'Profile',
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.grid_view),
                                label: 'More',
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
