import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:kothai_app/enums/KeyTypeEnum.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:kothai_app/presentation/shared/keyboard/key_model.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:kothai_app/presentation/providers/keyboard/keyboard_provider.dart';

class KeyButton extends ConsumerWidget {
    final KeyModel keyModel;
    final KeyboardController controller;
    final Color? bgColor;

    const KeyButton({
        super.key,
        required this.keyModel,
        required this.controller,
        this.bgColor,
    });

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final heldKey = ref.watch(holdKeyProvider);
        final sessionState = ref.watch(sessionStateProvider);

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
                        'Schemes/Surface Dim',
                    ).withValues(red: 0, green: 0, blue: 0).withAlpha(40),
            KeyType.functional =>
            bgColor ?? getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            KeyType.symbolic =>
            bgColor ?? getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
            KeyType.special =>
            bgColor ??
                getFigmaColor(context, 'State Layers/Inverse Surface/Opacity-16'),
            KeyType.colored => bgColor ?? Color.fromARGB(255, 26, 115, 233),
        };
        return GestureDetector(
            onTap: keyModel.onTap == null ? null : () => {
                    keyModel.onTap!(controller),
                    sessionState.isPaused ? ref.read(sessionStateProvider.notifier).resume() : null,
                },
            child: Container(
                constraints: const BoxConstraints(minWidth: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(5.46),
                ),
                alignment: Alignment.center,
                child: keyModel.label == ''
                    ? (keyModel.icon != null
                        ? Icon(
                            keyModel.icon,
                            size: 16,
                            color: switch (keyModel.type) {
                                KeyType.colored => Colors.white,
                                _ => getFigmaColor(context, 'Schemes/On Background'),
                            },
                        )
                        : const SizedBox.shrink())
                    : Text(
                        keyModel.label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: switch (keyModel.type) {
                                KeyType.colored => Colors.white,
                                _ => getFigmaColor(context, 'Schemes/On Background'),
                            },
                        ),
                    ),
            ),
        );
    }
}
