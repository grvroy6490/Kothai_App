import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/typing_session/domain/enums/keyboard_type_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/keyboard/keyboard_provider.dart';
import 'dart:async';

import 'package:kothai_app/features/typing_session/presentation/widgets/keyboard/key_model.dart';

class KeyButton extends ConsumerWidget {
    final KeyModel keyModel;
    final KeyboardController controller;
    final Color? bgColor;
    final void Function(KeyboardController)? longTap;

    const KeyButton({
        super.key,
        required this.keyModel,
        required this.controller,
        this.bgColor,
        this.longTap
    });

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final heldKey = ref.watch(holdKeyProvider);
        // final sessionState = ref.watch(sessionStateProvider);

        final isHeld = heldKey == keyModel.label;
        final bg = switch (keyModel.type) {
            KeyType.uyir =>
            bgColor ??
                getFigmaColor(context, 'State Layers/Inverse Surface/Opacity-16'),
            KeyType.mei =>
            bgColor ?? getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            KeyType.diacritic =>
            isHeld
                ? Colors.blue.withAlpha(67) // Highlight held diacritics
                : bgColor ??
                    getFigmaColor(
                        context,
                        'Schemes/Surface Dim'
                    ).withValues(red: 0, green: 0, blue: 0).withAlpha(40),
            KeyType.functional =>
            bgColor ?? getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            KeyType.symbolic =>
            bgColor ?? getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            KeyType.special =>
            bgColor ??
                getFigmaColor(context, 'State Layers/Inverse Surface/Opacity-16'),
            KeyType.colored => bgColor ?? Color.fromARGB(255, 26, 115, 233)
        };
        return GestureDetector(
            onTap: keyModel.onTap == null ? null : () => {
                    keyModel.onTap!(controller),
                    // sessionState.isPaused ? ref.read(sessionStateProvider.notifier).resume() : null
                },
            onLongPress: (longTap == null || !(keyModel.label.toLowerCase() == 'backspace' || keyModel.icon == Icons.backspace))
                ? null
                : () {
                    longTap!(controller);
                    if (keyModel.label.toLowerCase() == 'backspace' || keyModel.icon == Icons.backspace) {
                        // Continue erasing while the key is held down
                        Timer.periodic(const Duration(milliseconds: 100), (timer) {
                                if (!controller.isKeyPressed) {
                                    timer.cancel();
                                } else {
                                    longTap!(controller);
                                }
                            });
                    }
                    // if (sessionState.isPaused) {
                    //     ref.read(sessionStateProvider.notifier).resume();
                    // }
                },
            child: Container(
                constraints: BoxConstraints(minWidth: Gap(context).gap(20)),
                padding: EdgeInsets.symmetric(vertical: Gap(context).gap(10)),
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(5.46)
                ),
                alignment: Alignment.center,
                child: keyModel.label == ''
                    ? (keyModel.icon != null
                        ? Icon(
                            keyModel.icon,
                            size: KxScale(context).sp(16),
                            color: switch (keyModel.type) {
                                KeyType.colored => Colors.white,
                                _ => getFigmaColor(context, 'Schemes/On Background')
                            }
                        )
                        : const SizedBox.shrink())
                    : Text(
                        keyModel.label,
                        style: TextStyle(
                            fontSize: KxScale(context).sp(13),
                            fontWeight: FontWeight.w500,
                            color: switch (keyModel.type) {
                                KeyType.colored => Colors.white,
                                _ => getFigmaColor(context, 'Schemes/On Background')
                            }
                        )
                    )
            )
        );
    }
}
