

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:kothai_app/enums/KeyTypeEnum.dart';
import 'package:kothai_app/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:kothai_app/presentation/shared/keyboard/key_button.dart';
import 'package:kothai_app/presentation/shared/keyboard/key_model.dart';
import 'package:kothai_app/presentation/shared/keyboard/keyboard_layout.dart';
import 'package:kothai_app/presentation/shared/keyboard/layouts/tamil_keyboard/letters.dart';

class TamilNumericKeyboardLayout extends ConsumerWidget {
    final KeyboardController controller;
    const TamilNumericKeyboardLayout({super.key, required this.controller});

    @override
    Widget build(BuildContext context, ref) {

        final List<String> symbolicLetters = [...Letters.symbols];

        return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
                // First Row - Uyir Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        for(int i = 0; i < 10; i++)
                            Expanded(
                                child: KeyButton(
                                    keyModel: KeyModel(id: 'numeric_$i', type: KeyType.uyir, label: '$i', onTap: (ctrl) => ctrl.insert('$i'),),
                                    controller: controller,
                                )
                            ),
                    ]
                ),

                // Second Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        ...symbolicLetters.sublist(0, 10).map((letter) {
                                return Expanded(
                                    flex: 2,
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
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'more_symbols', type: KeyType.functional, label: '=/>', onTap: (ctrl) => ref.read(keyboardLayoutProvider.notifier).setsymbolic()),
                                controller: controller,
                            )
                        ),
                        ...symbolicLetters.sublist(10, 17).map((letter) {
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

                // Fourth Row - Space, Backspace
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
