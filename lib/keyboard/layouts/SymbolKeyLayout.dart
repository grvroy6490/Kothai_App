
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/KeyboardEnum.dart';
import 'package:kothai_app/keyboard/keys/colorKey.dart';
import 'package:kothai_app/keyboard/keys/functionalKey.dart';
import 'package:kothai_app/keyboard/keys/symbolicKey.dart';
import 'package:kothai_app/keyboard/keys/uyirKey.dart';


Widget BuildSymbolKeysLayout(
    BuildContext context,
    void Function(String)? onKeyPressed,
    void Function(KeyboardType)? changeKeyboardLayout
){
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
                            label: '~',
                            onPressed: () => {
                                onKeyPressed?.call('~')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '^',
                            onPressed: () => {
                                onKeyPressed?.call('^')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '|',
                            onPressed: () => {
                                onKeyPressed?.call('|')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '•',
                            onPressed: () => {
                                onKeyPressed?.call('•')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '√',
                            onPressed: () => {
                                onKeyPressed?.call('√')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: 'π',
                            onPressed: () => {
                                onKeyPressed?.call('π')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '±',
                            onPressed: () => {
                                onKeyPressed?.call('±')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '+',
                            onPressed: () => {
                                onKeyPressed?.call('+')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '×',
                            onPressed: () => {
                                onKeyPressed?.call('×')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '§',
                            onPressed: () => {
                                onKeyPressed?.call('§')
                            },
                        )),
                ],
            ),

            // Second Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 1,
                children: [
                    Expanded(child: Uyirkey(
                            label: '\$',
                            onPressed: () => {
                                onKeyPressed?.call('\$')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '௹',
                            onPressed: () => {
                                onKeyPressed?.call('௹')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '£',
                            onPressed: () => {
                                onKeyPressed?.call('£')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '€',
                            onPressed: () => {
                                onKeyPressed?.call('€')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '¥',
                            onPressed: () => {
                                onKeyPressed?.call('¥')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '°',
                            onPressed: () => {
                                onKeyPressed?.call('°')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '=',
                            onPressed: () => {
                                onKeyPressed?.call('=')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '{',
                            onPressed: () => {
                                onKeyPressed?.call('{')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '}',
                            onPressed: () => {
                                onKeyPressed?.call('}')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '\\',
                            onPressed: () => {
                                onKeyPressed?.call('\\')
                            },
                        )),
                ],
            ),

            // Third Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 1,
                children: [
                    Expanded(flex: 2, child: FunctionalKey(
                            iconOrText: '?123',
                            onPressed: () => {
                                changeKeyboardLayout!(KeyboardType.number)
                            },
                        ),
                    ),
                    Expanded(child: Uyirkey(
                            label: '%',
                            onPressed: () => {
                                onKeyPressed?.call('%')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '©',
                            onPressed: () => {
                                onKeyPressed?.call('©')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '®',
                            onPressed: () => {
                                onKeyPressed?.call('®')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '™',
                            onPressed: () => {
                                onKeyPressed?.call('™')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '✓',
                            onPressed: () => {
                                onKeyPressed?.call('✓')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: '[',
                            onPressed: () => {
                                onKeyPressed?.call('[')
                            },
                        )),
                    Expanded(child: Uyirkey(
                            label: ']',
                            onPressed: () => {
                                onKeyPressed?.call(']')
                            },
                        )),
                    Expanded(flex: 2, child: FunctionalKey(
                            iconOrText: FontAwesomeIcons.deleteLeft,
                            onPressed: () => {
                                onKeyPressed?.call('delete')
                            },
                        ),
                    ),
                ],
            ),

            // Fourth Row
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 1,
                children: [
                    Expanded(flex: 2, child: FunctionalKey(
                            iconOrText: 'அ/a',
                            onPressed: () => {
                                changeKeyboardLayout!(KeyboardType.tamil)
                            },
                        ),),
                    Expanded(flex: 1, child: FunctionalKey(
                            iconOrText: '<',
                            onPressed: () => {
                                onKeyPressed?.call('<')
                            },
                        )),
                    Expanded(flex: 4, child: Symbolickey(
                            label: ' ',
                            onPressed: () => {
                                onKeyPressed?.call('space')
                            },
                        ),),
                    Expanded(flex: 1, child: FunctionalKey(
                            iconOrText: '>',
                            onPressed: () => {
                                onKeyPressed?.call('>')
                            },
                        )),
                    Expanded(flex: 2,
                        child: Colorkey(
                            data: Icons.keyboard_return,
                            fontSize: 20,
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


