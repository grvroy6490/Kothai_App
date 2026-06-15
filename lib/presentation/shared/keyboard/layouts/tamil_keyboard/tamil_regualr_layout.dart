import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/enums/KeyTypeEnum.dart';
import 'package:visai/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:visai/presentation/shared/keyboard/key_button.dart';
import 'package:visai/presentation/shared/keyboard/key_model.dart';
import 'package:visai/presentation/shared/keyboard/keyboard_layout.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/letters.dart';

class TamilRegularKeyboardLayout extends ConsumerWidget {
    final KeyboardController controller;

    // Make defensive copies
    final List<String> uyirLetters = [...Letters.uyirLetters];
    final List<String> meiLetters = [...Letters.meiLetters];
    final List<String> leftDiacriticLetters = [...Letters.leftDiacriticLetters];
    final List<String> rightDiacriticLetters = [...Letters.rightDiacriticLetters];
    final List<String> specialLetters = [...Letters.specialKeys];

    TamilRegularKeyboardLayout({
        super.key,
        required this.controller,
    });

    // Build the row lazily; safe to reference other fields.
    late final List<KeyModel> firstRow = uyirLetters.sublist(0,10).map((letter) {
            return KeyModel(id: 'uyir_$letter', type: KeyType.uyir, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
        }).toList();

    // Build the row lazily; safe to reference other fields.
    late final List<KeyModel> secondRow = [
        KeyModel(id: 'diacritic_${leftDiacriticLetters[0]}', type: KeyType.diacritic, label: leftDiacriticLetters[0], onTap: (ctrl) => ctrl.insert(leftDiacriticLetters[0]),),

        /***********************************************/
        ...meiLetters.sublist(0, 3).map((letter) {
                return KeyModel(id: 'mei_$letter', type: KeyType.mei, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

        /***********************************************/
        KeyModel(id: 'uyir_${uyirLetters[10]}', type: KeyType.uyir, label: uyirLetters[10], onTap: (ctrl) => ctrl.insert(uyirLetters[10]),),

        /***********************************************/
        ...meiLetters.sublist(3, 6).map((letter) {
                return KeyModel(id: 'mei_$letter', type: KeyType.mei, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

        /***********************************************/
        ...rightDiacriticLetters.sublist(0, 2).map((letter) {
                return KeyModel(id: 'diacritic_$letter', type: KeyType.diacritic, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),
    ];

    // Build the row lazily; safe to reference other fields.
    late final List<KeyModel> thirdRow = [
        KeyModel(id: 'diacritic_${leftDiacriticLetters[1]}', type: KeyType.diacritic, label: leftDiacriticLetters[1], onTap: (ctrl) => ctrl.insert(leftDiacriticLetters[1]),),

        /***********************************************/
        ...meiLetters.sublist(6, 13).map((letter) {
                return KeyModel(id: 'mei_$letter', type: KeyType.mei, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

        /***********************************************/
        ...rightDiacriticLetters.sublist(2, 4).map((letter) {
                return KeyModel(id: 'diacritic_$letter', type: KeyType.diacritic, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),
    ];

    // Build the row lazily; safe to reference other fields.
    late final List<KeyModel> fourthRow = [
        KeyModel(id: 'diacritic_${leftDiacriticLetters[2]}', type: KeyType.diacritic, label: leftDiacriticLetters[2], onTap: (ctrl) => ctrl.insert(leftDiacriticLetters[2]),),

        /***********************************************/
        ...meiLetters.sublist(13, meiLetters.length).map((letter) {
                return KeyModel(id: 'mei_$letter', type: KeyType.mei, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

        /***********************************************/
        ...rightDiacriticLetters.sublist(4, rightDiacriticLetters.length).map((letter) {
                return KeyModel(id: 'diacritic_$letter', type: KeyType.diacritic, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

    ];

    // Build the row lazily; safe to reference other fields.
    late final List<KeyModel> fifthRow = [
        KeyModel(id: 'symbol_comma', type: KeyType.symbolic, label: ',', onTap: (ctrl) => ctrl.insert(','),),
        KeyModel(id: 'symbol_${specialLetters[0]}', type: KeyType.symbolic, label: specialLetters[0], onTap: (ctrl) => ctrl.insert(specialLetters[0]),),

        /***********************************************/
        ...specialLetters.sublist(1, specialLetters.length).map((letter) {
                return KeyModel(id: 'symbol_$letter', type: KeyType.special, label: letter, onTap: (ctrl) => ctrl.insert(letter),);
            }),

    ];

    @override
    Widget build(BuildContext context, ref) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
                // First Row - Uyir Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: firstRow.map((keyModel) {
                            return Expanded(
                                child: KeyButton(
                                    keyModel: keyModel,
                                    controller: controller,
                                )
                            );
                        }).toList(),
                ),

                // Second Row - Left Diacritic + Mei Letters
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: secondRow.map((keyModel) {
                            return Expanded(
                                child: KeyButton(
                                    keyModel: keyModel,
                                    controller: controller,
                                )
                            );
                        }).toList(),
                ),

                // Third Row - Mei Letters + Right Diacritic
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: thirdRow.map((keyModel) {
                            return Expanded(
                                child: KeyButton(
                                    keyModel: keyModel,
                                    controller: controller,
                                )
                            );
                        }).toList(),
                ),

                // Fourth Row - Mei Letters + Right Diacritic
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        Expanded(child: Text(' ')),
                        ...fourthRow.map((keyModel) {
                                return Expanded(
                                    child: KeyButton(
                                        keyModel: keyModel,
                                        controller: controller,
                                    )
                                );
                            }),
                        Expanded(child: Text(' '))
                    ]
                ),

                // Fifth Row - Space, Backspace
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 2,
                    children: [
                        ...fifthRow.map((keyModel) {
                                return Expanded(
                                    child: KeyButton(
                                        keyModel: keyModel,
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

                // Sixth Row - Space, Backspace
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
                        Expanded(
                            flex: 1,
                            child: KeyButton(
                                keyModel: KeyModel(id: 'language', type: KeyType.functional, label: '', icon: Icons.language, onTap: (ctrl) => {},),
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

            ],
        );
    }
}
