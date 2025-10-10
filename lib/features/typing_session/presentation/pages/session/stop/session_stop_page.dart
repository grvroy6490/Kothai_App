import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/practice_page.dart';
import 'package:kothai_app/di/providers/navigation/navigation_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';

class SessionStopPage extends ConsumerStatefulWidget {
    const SessionStopPage({super.key});

    @override
    ConsumerState<SessionStopPage> createState() => _SessionStopPageState();
}

class _SessionStopPageState extends ConsumerState<SessionStopPage> {

    @override
    Widget build(BuildContext context) {
        final typingProgress = ref.watch(typingProgressProvider);
        final sessionMode = ref.watch(sessionStatusControllerProvider).mode;

        final args = Get.arguments;
        // 🚀 METHODS --------------------------------
        void handleSessionStop(){
            ref.read(sessionStatusControllerProvider.notifier).reset();
            // Clear text controller if provided
            try {
                if (args is Map && args['controller'] is TextEditingController) {
                    final TextEditingController c = args['controller'] as TextEditingController;
                    c.clear();
                }
            } catch (_) {
            }

            // Return result to caller; let caller handle nav/index changes to avoid key duplication
            final route = (args is Map && args.containsKey('route')) ? args['route'] as String : (args is String ? args : Get.currentRoute);
            final index = (args is Map && args.containsKey('index')) ? args['index'] as int? : null;

            Get.back(result: {
                    'confirmed': true,
                    'route': route,
                    'index': index
                });
        }

        void handleSessionStopDenied(){
            Get.back(result: {'confirmed': false});
        }

        // ⭐ Widget ---------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: [
                        Opacity(opacity: 0.5,
                            child: Image.asset('assets/images/Pattern.png',
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
                                                        left:0,
                                                        bottom: 0,
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Container(
                                                                constraints: BoxConstraints(
                                                                    minWidth: MediaQuery.of(context).size.width - 32
                                                                ),
                                                                height: Gap(context).gap(315),
                                                                padding: EdgeInsets.all(Gap(context).gap(16)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: getFigmaColor(context, 'State Layers/Error/Opacity-08')
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
                                                                        color: getFigmaColor(context, 'Schemes/Error Container'),
                                                                        borderRadius: BorderRadius.circular(100)
                                                                    ),
                                                                    child: Icon(Icons.front_hand_outlined, size: KxScale(context).sp(60), color: getFigmaColor(context, 'Schemes/Error'))
                                                                ),
                                                                SizedBox(height: Gap(context).gap(30)),
                                                                Text(sessionMode == SessionMode.practice ? 'Stop Practice' : 'Stop Challenge', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                        color: getFigmaColor(context, 'Schemes/Error'),
                                                                        fontWeight: FontWeight.w600
                                                                    )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(10)),
                                                                SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                                    child: Center(
                                                                        child: Text('Are you sure you want to end this practice?',
                                                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                                color: getFigmaColor(context, 'Schemes/On Surface')
                                                                            ),
                                                                            textAlign: TextAlign.center
                                                                        )
                                                                    )

                                                                ),
                                                                SizedBox(height: Gap(context).gap(15)),
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: getFigmaColor(context, 'State Layers/Error/Opacity-08'),
                                                                        borderRadius: BorderRadius.circular(30)
                                                                    ),
                                                                    padding: EdgeInsets.all(6),
                                                                    child: Row(
                                                                        children: [
                                                                            Container(
                                                                                padding: EdgeInsets.all(Gap(context).gap(12)),
                                                                                decoration: BoxDecoration(
                                                                                    color: getFigmaColor(context, 'State Layers/Error/Opacity-08'),
                                                                                    borderRadius: BorderRadius.circular(100)
                                                                                ),
                                                                                child: Icon(Icons.warning, size: KxScale(context).sp(25), color: getFigmaColor(context, 'Schemes/Error'))
                                                                            ),
                                                                            SizedBox(width: Gap(context).gap(14)),
                                                                            Expanded(
                                                                                child: Text("Congratulations on reaching ${(typingProgress * 100).toStringAsFixed(0)}%! If you choose to stop now, your progress won't be saved in your statistics.",
                                                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                        color: getFigmaColor(context, 'Schemes/Error')
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
                                                                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: Gap(context).gap(16))),
                                                                                    backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/On Error')),
                                                                                    foregroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/Error'))
                                                                                ),
                                                                                onPressed: () => handleSessionStop(),
                                                                                child: Text('Yes, Stop it', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                                        color: getFigmaColor(context, 'Schemes/Error')
                                                                                    )
                                                                                )
                                                                            )
                                                                        ),

                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/On Surface Variant')),
                                                                                    foregroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/Surface Variant')),
                                                                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: Gap(context).gap(16)))
                                                                                ),
                                                                                onPressed: () => handleSessionStopDenied(),
                                                                                child: Text('No', style: Theme.of(context).textTheme.bodyLarge)
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
