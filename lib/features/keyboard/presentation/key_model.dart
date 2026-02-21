import 'package:flutter/material.dart';
import 'package:visai/features/typing_session/domain/enums/keyboard_type_enum.dart';

class KeyModel {
  final String id;
  final KeyType type;
  final String label;
  final IconData? icon;
  final VoidCallbackTap? onTap;
  final List<String>? holdOptions;

  const KeyModel({required this.id, required this.type, required this.label, this.onTap, this.holdOptions, this.icon });
}
