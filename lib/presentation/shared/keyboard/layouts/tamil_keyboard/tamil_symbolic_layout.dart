

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/enums/KeyTypeEnum.dart';
import 'package:visai/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:visai/presentation/shared/keyboard/key_button.dart';
import 'package:visai/presentation/shared/keyboard/key_model.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/letters.dart';

class TamilSymbolicKeyboardLayout extends ConsumerWidget {
    final KeyboardController controller;
    const TamilSymbolicKeyboardLayout({super.key, required this.controller});

    @override
    Widget build(BuildContext context, ref) {

        final List<String> symbolicLetters = [...Letters.symbols];

        return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
                // First Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        ...symbolicLetters.sublist(17, 27).map((letter) {
                                return Expanded(
                                    flex: 1,
                                    child: KeyButton(
                                        keyModel: KeyModel(id: 'numeric_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter)),
                                        controller: controller,
                                    )
                                );
                            })
                    ]
                ),

                // Second Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        ...symbolicLetters.sublist(27, 37).map((letter) {
                                return Expanded(
                                    flex: 1,
                                    child: KeyButton(
                                        keyModel: KeyModel(id: 'numeric_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter)),
                                        controller: controller,
                                    )
                                );
                            })
                    ]
                ),

                // Third Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'numeric', type: KeyType.functional, label: '?123', onTap: (ctrl) => {ref.read(keyboardLayoutProvider.notifier).setNumeric(),},),
                                controller: controller,
                            )
                        ),
                        ...symbolicLetters.sublist(37, symbolicLetters.length).map((letter) {
                                return Expanded(
                                    flex: 1,
                                    child: KeyButton(
                                        keyModel: KeyModel(id: 'numeric_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter)),
                                        controller: controller,
                                    )
                                );
                            }),
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'backspace', type: KeyType.functional, label: '', icon: Icons.backspace_outlined, onTap: (ctrl) => ctrl.backspace(''),),
                                controller: controller,
                            )
                        )
                    ]
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'regular', type: KeyType.functional, label: 'அ/a', onTap: (ctrl) => {ref.read(keyboardLayoutProvider.notifier).setRegular(),},),
                                controller: controller,
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'comma', type: KeyType.functional, label: ',', onTap: (ctrl) => ctrl.insert(','),),
                                controller: controller,
                            )
                        ),
                        Expanded(
                            flex: 4,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'space', type: KeyType.functional, label: ' ', onTap: (ctrl) => ctrl.insert(' '),),
                                controller: controller,
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'period', type: KeyType.symbolic, label: '.', onTap: (ctrl) => ctrl.insert('.'),),
                                controller: controller,
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'enter', type: KeyType.colored, label: '', icon: Icons.keyboard_return, onTap: (ctrl) => ctrl.insert('\n'),),
                                controller: controller,
                            )
                        ),

                    ]
                ),
            ]
        );
    }
}
