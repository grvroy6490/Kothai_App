import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/KeyboardEnum.dart';
import 'package:kothai_app/keyboard/keys/colorKey.dart';
import 'package:kothai_app/keyboard/keys/diacriticKey.dart';
import 'package:kothai_app/keyboard/keys/functionalKey.dart';
import 'package:kothai_app/keyboard/keys/meiKey.dart';
import 'package:kothai_app/keyboard/keys/specialKey.dart';
import 'package:kothai_app/keyboard/keys/symbolicKey.dart';
import 'package:kothai_app/keyboard/keys/uyirKey.dart';
import 'package:kothai_app/provider/HoldingKeyModel.dart';
import 'package:provider/provider.dart';



Widget BuildTamilKeysLayout(
    BuildContext context, 
    void Function(String)? onKeyPressed,
    void Function(KeyboardType)? changeKeyboardLayout,
){
    final holdKey = context.watch<HoldKeyModel>().hold;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 1,
        children: [
            // First Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 1,
                children: [
                    Expanded(child: Uyirkey(
                            label: 'அ',
                            onPressed: () => {
                                onKeyPressed?.call('அ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஆ',
                            onPressed: () => {
                                onKeyPressed?.call('ஆ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'இ',
                            onPressed: () => {
                                onKeyPressed?.call('இ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஈ',
                            onPressed: () => {
                                onKeyPressed?.call('ஈ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'உ',
                            onPressed: () => {
                                onKeyPressed?.call('உ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஊ',
                            onPressed: () => {
                                onKeyPressed?.call('ஊ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'எ',
                            onPressed: () => {
                                onKeyPressed?.call('எ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஏ',
                            onPressed: () => {
                                onKeyPressed?.call('ஏ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஒ',
                            onPressed: () => {
                                onKeyPressed?.call('ஒ')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஓ',
                            onPressed: () => {
                                onKeyPressed?.call('ஓ')
                            },
                        )),
                ],
            ),

            // Second Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 1,
                children: [
                    Expanded(child: Diacritickey(
                            label: 'ெ',
                            isActive: holdKey == 'ெ',
                            onPressed: () => {
                                onKeyPressed?.call('ெ')
                            }
                        )),
                    Expanded(child: Meikey(
                            label: 'ம',
                            onPressed: () => {
                                onKeyPressed?.call('ம')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ச',
                            onPressed: () => {
                                onKeyPressed?.call('ச')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ற',
                            onPressed: () => {
                                onKeyPressed?.call('ற')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'ஐ',
                            onPressed: () => {
                                onKeyPressed?.call('ஐ')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ய',
                            onPressed: () => {
                                onKeyPressed?.call('ய')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'வ',
                            onPressed: () => {
                                onKeyPressed?.call('வ')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ண',
                            onPressed: () => {
                                onKeyPressed?.call('ண')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: 'ி',
                            onPressed: () => {

                                onKeyPressed?.call('ி')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: 'ீ',
                            onPressed: () => {
                                onKeyPressed?.call('ீ')
                            },
                        )),
                ],
            ),

            // Third Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 1,
                children: [
                    Expanded(child: Diacritickey(
                            label: 'ே',
                            isActive: holdKey == 'ே',
                            onPressed: () => {
                                onKeyPressed?.call('ே')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'க',
                            onPressed: () => {
                                onKeyPressed?.call('க')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ந',
                            onPressed: () => {
                                onKeyPressed?.call('ந')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ர',
                            onPressed: () => {
                                onKeyPressed?.call('ர')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ங',
                            onPressed: () => {
                                onKeyPressed?.call('ங')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ப',
                            onPressed: () => {
                                onKeyPressed?.call('ப')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ல',
                            onPressed: () => {
                                onKeyPressed?.call('ல')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ன',
                            onPressed: () => {
                                onKeyPressed?.call('ன')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: 'ு',
                            onPressed: () => {
                                onKeyPressed?.call('ு')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: 'ூ',
                            onPressed: () => {
                                onKeyPressed?.call('ூ')
                            },
                        )),
                ],
            ),

            // Fourth Row
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 1,
                children: [
                    Expanded(child: SizedBox()),
                    Expanded(child: Diacritickey(
                            label: 'ை',
                            isActive: holdKey == 'ை',
                            onPressed: () => {
                                onKeyPressed?.call('ை')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'த',
                            onPressed: () => {
                                onKeyPressed?.call('த')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ட',
                            onPressed: () => {
                                onKeyPressed?.call('ட')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ஞ',
                            onPressed: () => {
                                onKeyPressed?.call('ஞ')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ழ',
                            onPressed: () => {
                                onKeyPressed?.call('ழ')
                            },
                        )),
                    Expanded(child: Meikey(
                            label: 'ள',
                            onPressed: () => {
                                onKeyPressed?.call('ள')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: '்',
                            onPressed: () => {
                                onKeyPressed?.call('்')
                            },
                        )),
                    Expanded(child: Diacritickey(
                            label: 'ா',
                            onPressed: () => {
                                onKeyPressed?.call('ா')
                            },
                        )),
                    Expanded(child: SizedBox())
                ],
            ),

            // Fifth Row
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 1,
                children: [
                    Expanded(child: Symbolickey(
                            label: ',',
                            onPressed: () => {
                                onKeyPressed?.call(',')
                            },
                        )),
                    Expanded(child: Symbolickey(
                            label: 'ஃ',
                            onPressed: () => {
                                onKeyPressed?.call('ஃ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'ஜ',
                            onPressed: () => {
                                onKeyPressed?.call('ஜ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'ஷ',
                            onPressed: () => {
                                onKeyPressed?.call('ஷ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'ஸ',
                            onPressed: () => {
                                onKeyPressed?.call('ஸ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'ஹ',
                            onPressed: () => {
                                onKeyPressed?.call('ஹ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'க்ஷ',
                            onPressed: () => {
                                onKeyPressed?.call('க்ஷ')
                            },
                        )),
                    Expanded(child: Specialkeys(
                            label: 'ஸ்ரீ',
                            onPressed: () => {
                                onKeyPressed?.call('ஸ்ரீ')
                            },
                        )),
                    Expanded(flex: 2, child: FunctionalKey(
                            iconOrText: FontAwesomeIcons.deleteLeft,
                            onPressed: () => {
                                onKeyPressed?.call('delete')
                            },
                        ),),
                ],
            ),

            // Sixth Row
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 1,
                children: [
                    Expanded(flex: 2, child: FunctionalKey(
                            iconOrText: '?123',
                            onPressed: () => {
                                changeKeyboardLayout!(KeyboardType.number)
                            },
                        ),),
                    Expanded(flex: 1, child: FunctionalKey(
                            iconOrText: FontAwesomeIcons.globe,
                            onPressed: () => {
                                onKeyPressed?.call('lang')
                            },
                        )),
                    Expanded(flex: 4, child: Symbolickey(
                            label: ' ',
                            onPressed: () => {
                                onKeyPressed?.call(' ')
                            },
                        ),),
                    Expanded(flex: 1, child: Symbolickey(
                            label: '.',
                            onPressed: () => {
                                onKeyPressed?.call('.')
                            },
                        )),
                    Expanded(flex: 2,
                        child: Colorkey(
                            data: Icons.keyboard_return,
                            bgColor: Color.fromARGB(255, 26, 115, 223),
                            color: Colors.white,
                            onPressed: () => {
                                onKeyPressed?.call('enter')
                            },
                        ),
                    ),
                ],
            ),
        ],
    );
}