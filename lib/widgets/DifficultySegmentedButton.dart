
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
    String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
    };

    int get index => switch (this) {
        Difficulty.easy => 0,
        Difficulty.medium => 1,
        Difficulty.hard => 2,
    };
}


class DifficultySegmented extends StatelessWidget {
    const DifficultySegmented({
        super.key,
        required this.value,
        required this.onChanged,
        this.height = 44,
        this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        this.radius = 999,
    });

    final Difficulty value;
    final ValueChanged<Difficulty> onChanged;
    final double height;
    final EdgeInsets padding;
    final double radius;

    @override
    Widget build(BuildContext context) {
        final scheme = Theme.of(context).colorScheme;

        // Colors (tweak if you’re using your Figma helpers)
        final pillBg        = scheme.surfaceVariant.withOpacity(0.6);
        final dividerColor  = scheme.onSurfaceVariant.withOpacity(0.28);
        final selectedBg    = scheme.inverseSurface;       // dark bubble
        final selectedFg    = scheme.onInverseSurface;     // white text
        final unselectedFg  = scheme.onSurfaceVariant;     // grey text

        // Layout
        final items = Difficulty.values;
        final selIndex = value.index;

        return Container(
            padding: padding,
            decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(radius),
            ),
            child: SizedBox(
                height: height,
                child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                        // Moving selected bubble
                        AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            alignment: _alignmentForIndex(selIndex, items.length),
                            child: FractionallySizedBox(
                                widthFactor: 1 / items.length,
                                heightFactor: 1.0,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                        color: selectedBg,
                                        borderRadius: BorderRadius.circular(radius),
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.12),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                            )
                                        ],
                                    ),
                                ),
                            ),
                        ),

                        // Labels + taps + vertical dividers
                        Row(
                            children: List.generate(items.length * 2 - 1, (i) {
                                    if (i.isOdd) {
                                        // Dividers between segments
                                        return SizedBox(
                                            width: 1,
                                            height: height * 0.55,
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: dividerColor,
                                                    borderRadius: BorderRadius.circular(1),
                                                ),
                                            ),
                                        );
                                    }

                                    final itemIndex = i ~/ 2;
                                    final item = items[itemIndex];
                                    final isSelected = itemIndex == selIndex;

                                    return Expanded(
                                        child: InkWell(
                                            borderRadius: BorderRadius.circular(radius),
                                            onTap: () => onChanged(item),
                                            child: Center(
                                                child: AnimatedDefaultTextStyle(
                                                    duration: const Duration(milliseconds: 150),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                                        color: isSelected ? selectedFg : unselectedFg,
                                                    ),
                                                    child: Text(item.label),
                                                ),
                                            ),
                                        ),
                                    );
                                }),
                        ),
                    ],
                ),
            ),
        );
    }

    // Aligns the chip to 0 (left), 0.5 (center), 1.0 (right)
    Alignment _alignmentForIndex(int index, int total) {
        if (total <= 1) return Alignment.center;
        final t = total - 1;
        final x = -1.0 + 2.0 * (index / t); // -1, 0, +1 for 3 items
        return Alignment(x, 0);
    }
}
