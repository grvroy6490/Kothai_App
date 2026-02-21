import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_renderer.dart';

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
