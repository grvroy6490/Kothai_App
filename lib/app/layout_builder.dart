import 'package:flutter/material.dart';
import 'package:kothai_app/app/layouts/mobile_layout.dart';
import 'package:kothai_app/app/layouts/tablet_layout.dart';

class ResponsivePage extends StatelessWidget {
    const ResponsivePage({super.key});

    static const mobileBreakpoint = 600.0; // px

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: LayoutBuilder(
                builder: (context, constraints) {
                    if (constraints.maxWidth < mobileBreakpoint) {
                        // 📱 Mobile layout
                        return MobileLayout();
                    } else {
                        // 📱➡️💻 Tablet layout
                        return TabletLayout();
                    }
                }
            )
        );
    }
}
