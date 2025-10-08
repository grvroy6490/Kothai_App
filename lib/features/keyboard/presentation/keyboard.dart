import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_renderer.dart';
import 'package:kothai_app/features/keyboard/presentation/providers/keyboard_provider.dart';

class Keyboard extends ConsumerWidget {
    final KeyboardController controller;
    final KeyboardRenderer renderer;
    const Keyboard({super.key, required this.controller, required this.renderer});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final layoutType = ref.watch(keyboardLayoutProvider);

        return renderer.build(controller, layoutType);
    }
}
