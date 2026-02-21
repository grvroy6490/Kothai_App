

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:visai/features/keyboard/presentation/key_model.dart';
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:visai/features/typing_session/domain/enums/keyboard_type_enum.dart';
import 'package:visai/features/keyboard/presentation/providers/keyboard_provider.dart';
import 'package:visai/features/keyboard/presentation/key_button.dart';

class TamilNumericKeyboardLayout extends ConsumerWidget {
    final KeyboardController controller;
    const TamilNumericKeyboardLayout({super.key, required this.controller});

    @override
    Widget build(BuildContext context, ref) {
        // final practiceConfig = ref.watch(practiceConfigurationProvider); // TODO: Unable practiceConfigurationProvider

        final List<String> symbolicLetters = [...Letters.symbols];

        return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Gap(context).gap(2),
            children: [
                // First Row - Uyir Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: Gap(context).gap(2),
                    children: [
                        for(int i = 0; i < 10; i++)
                            Expanded(
                                child: KeyButton(
                                    keyModel: KeyModel(id: 'numeric_$i', type: KeyType.uyir, label: '$i', onTap: (ctrl) => ctrl.insert('$i')),
                                    controller: controller
                                )
                            )
                    ]
                ),

                // Second Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: Gap(context).gap(2),
                    children: [
                        ...symbolicLetters.sublist(0, 10).map((letter) {
                                return Expanded(
                                    flex: 2,
                                    child: KeyButton(
                                        keyModel: KeyModel(id: 'numeric_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter)),
                                        controller: controller
                                    )
                                );
                            })
                    ]
                ),

                // Second Row - Symbols Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: Gap(context).gap(2),
                    children: [
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'more_symbols', type: KeyType.functional, label: '=/>', onTap: (ctrl) =>
                                    {
                                        ref
                                            .read(keyboardLayoutProvider.notifier)
                                            .setsymbolic()
                                    }),
                                controller: controller
                            )
                        ),
                        ...symbolicLetters.sublist(10, 17).map((letter) {
                                return Expanded(
                                    flex: 1,
                                    child: KeyButton(
                                        keyModel: KeyModel(id: 'numeric_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter)),
                                        controller: controller
                                    )
                                );
                            }),

                        //if(practiceConfig.allowTakeBacks) // 👈 ALLOW TAKEBACKS SETTINGS // TODO: Unable practiceConfigurationProvider
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'backspace', type: KeyType.functional, label: '', icon: Icons.backspace_outlined, onTap: (ctrl) => ctrl.backspace('')),
                                controller: controller
                            )
                        )
                    ]
                ),

                // Fourth Row - Space, Backspace
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: Gap(context).gap(2),
                    children: [
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'regular', type: KeyType.functional, label: 'அ/a', onTap: (ctrl) => {ref.read(keyboardLayoutProvider.notifier).setRegular()}),
                                controller: controller
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'comma', type: KeyType.functional, label: ',', onTap: (ctrl) => ctrl.insert(',')),
                                controller: controller
                            )
                        ),
                        Expanded(
                            flex: 4,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'space', type: KeyType.functional, label: ' ', onTap: (ctrl) => ctrl.insert(' ')),
                                controller: controller
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'period', type: KeyType.symbolic, label: '.', onTap: (ctrl) => ctrl.insert('.')),
                                controller: controller
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'enter', type: KeyType.colored, label: '', icon: Icons.keyboard_return, onTap: (ctrl) => ctrl.insert('\n')),
                                controller: controller
                            )
                        )

                    ]
                )
            ]
        );
    }
}
