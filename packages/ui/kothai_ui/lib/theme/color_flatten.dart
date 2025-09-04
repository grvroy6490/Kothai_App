import 'package:flutter/material.dart';

Map<String, Color> flattenColorMap(Map<String, dynamic> nested) {
  final out = <String, Color>{};

  void walk(String prefix, Map<String, dynamic> node) {
    node.forEach((k, v) {
      final key = prefix.isEmpty ? k : '$prefix/$k';
      if (v is Color) {
        out[key] = v;
      } else if (v is Map) {
        walk(key, Map<String, dynamic>.from(v));
      }
    });
  }

  walk('', nested);
  return out;
}
