

import 'package:characters/characters.dart';
<<<<<<< HEAD
import 'dart:math';
=======
>>>>>>> 12fa72b (updated IOS build)

int graphemeCount(String s) => s.characters.length;



double computeProgress(String typed, String target) {
    final typedCount = typed.characters.length;
    final totalCount = target.characters.length;

    if (totalCount == 0) return 0.0;

    // Clamp: if user typed more than target, keep max at 1.0
    return (typedCount / totalCount).clamp(0.0, 1.0);
}
