import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';

class SessionResetPage extends ConsumerStatefulWidget {
    final TextEditingController controller;
    const SessionResetPage({super.key, required this.controller});

    @override
    ConsumerState<SessionResetPage> createState() => _SessionResetPageState();
}

class _SessionResetPageState extends ConsumerState<SessionResetPage> {
    @override
    Widget build(BuildContext context) {
        // 📃 DECLARATION ----------------------------
        // 🌐 PROVIDERS ------------------------------
        final typingProgress = ref.watch(typingProgressProvider);

        // 🚀 METHODS --------------------------------
        void handlePracticeReset() {
            ref.read(sessionControllerProvider.notifier).restart();
            var arguments = Get.arguments;
            widget.controller.clear();

            if (arguments == kReset) {
                Get.back();
            } else if (arguments == kPause) {
                Get.back();
                Get.back();
            }
        }

        void handlePracticeResetDenied() {
            Get.back();
        }

        // ⭐ Widget ---------------------------------
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
                                                                height: Gap(context).gap(315),
                                                                padding: EdgeInsets.all(Gap(context).gap(16)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'State Layers/Secondary/Opacity-08'
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
                                                                    padding: EdgeInsets.all(Gap(context).gap(25)),
                                                                    decoration: BoxDecoration(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Secondary'
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100)
                                                                    ),
                                                                    child: Icon(
                                                                        Icons.history,
                                                                        size: KxScale(context).sp(60),
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/Secondary'
                                                                        )
                                                                    )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(30)),
                                                                Text(
                                                                    'Reset Progress',
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
                                                                SizedBox(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.8,
                                                                    child: Center(
                                                                        child: Text(
                                                                            'Are you sure you want to reset your progress in this practice?',
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
                                                                SizedBox(height: Gap(context).gap(15)),
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'State Layers/Secondary/Opacity-08'
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(30)
                                                                    ),
                                                                    padding: EdgeInsets.all(6),
                                                                    child: Row(
                                                                        children: [
                                                                            Container(
                                                                                padding: EdgeInsets.all(
                                                                                    Gap(context).gap(12)
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'State Layers/Secondary/Opacity-08'
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                        100
                                                                                    )
                                                                                ),
                                                                                child: Icon(
                                                                                    Icons.warning,
                                                                                    size: KxScale(context).sp(25),
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'Schemes/Secondary'
                                                                                    )
                                                                                )
                                                                            ),
                                                                            SizedBox(width: Gap(context).gap(14)),
                                                                            Expanded(
                                                                                child: Text(
                                                                                    "You've made it to ${(typingProgress * 100).toStringAsFixed(0)}%! If you reset your progress, it will return to 0%.",
                                                                                    style: Theme.of(context)
                                                                                        .textTheme
                                                                                        .bodyMedium
                                                                                        ?.copyWith(
                                                                                            color: getFigmaColor(
                                                                                                context,
                                                                                                'Schemes/Secondary'
                                                                                            )
                                                                                        )
                                                                                )
                                                                            )
                                                                        ]
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
                                                                                onPressed: () => handlePracticeReset(),
                                                                                child: Text(
                                                                                    'Yes, Reset it',
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
                                                                        ),

                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    backgroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Surface Variant'
                                                                                        )
                                                                                    ),
                                                                                    foregroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/Surface Variant'
                                                                                        )
                                                                                    ),
                                                                                    padding: WidgetStateProperty.all(
                                                                                        EdgeInsets.symmetric(
                                                                                            horizontal: 0,
                                                                                            vertical: Gap(context).gap(16)
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                onPressed: () =>
                                                                                handlePracticeResetDenied(),
                                                                                child: Text(
                                                                                    'No',
                                                                                    style: Theme.of(
                                                                                        context
                                                                                    ).textTheme.bodyLarge
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
