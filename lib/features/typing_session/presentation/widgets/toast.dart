import 'package:flutter/material.dart';
import 'package:visai/core/theme/figma_color.dart';

class Toast extends StatefulWidget {
    final Color bgColor;
    final Color textColor;
    final String label;
    final int? animationTime; // in seconds
    final bool showToast;
    void Function() onClosePressed;
    /// Called when the progress animation finishes (reaches 100%).
    final VoidCallback? onCompleted;

    /// Called when the user taps the close icon.
    final VoidCallback? onDismissed;

    /// If true, the toast hides itself when the animation completes.
    final bool autoHideOnComplete;

    Toast({
        super.key,
        required this.label,
        required this.bgColor,
        required this.textColor,
        this.animationTime,
        required this.showToast,
        this.onCompleted,
        this.onDismissed,
        this.autoHideOnComplete = true,
        required this.onClosePressed
    });

    @override
    State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _progressAnimation;

    // Local visibility so we can auto-hide without mutating the widget.
    bool _visible = false;

    @override
    void initState() {
        super.initState();
        _animationController = AnimationController(
            vsync: this,
            duration: Duration(seconds: widget.animationTime ?? 3)
        );

        _progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(_animationController);

        _animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                    // Fire callback first.
                    widget.onCompleted?.call();
                    // Then optionally auto-hide.
                    if (widget.autoHideOnComplete && mounted) {
                        setState(() => _visible = false);
                    }
                }
            });

        // Initial visibility & start
        _visible = widget.showToast;
        if (_visible) {
            _animationController.forward(from: 0.0);
        }
    }

    @override
    void didUpdateWidget(covariant Toast oldWidget) {
        super.didUpdateWidget(oldWidget);

        // Update duration if animationTime changed.
        if (widget.animationTime != oldWidget.animationTime) {
            _animationController.duration =
            Duration(seconds: widget.animationTime ?? 3);
        }

        // Handle visibility & animation restarts.
        if (widget.showToast && !oldWidget.showToast) {
            _visible = true;
            _animationController.forward(from: 0.0);
        } else if (!widget.showToast && oldWidget.showToast) {
            _animationController.stop();
            _visible = false;
        }
    }

    @override
    void dispose() {
        _animationController.dispose();
        super.dispose();
    }


    @override
    Widget build(BuildContext context) {
        if (!widget.showToast && !_visible) {
            return const SizedBox.shrink();
        }

        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(30)
            ),
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 15),
            child: Stack(
                children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: Text(
                                    widget.label,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: widget.textColor,
                                        height: 1
                                    )
                                )
                            ),
                            SizedBox(width: 15),
                            IconButton(
                                style: ButtonStyle(
                                    visualDensity: VisualDensity.compact
                                ),
                                onPressed: widget.onClosePressed,
                                icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: getFigmaColor(context, 'Schemes/Secondary')
                                )
                            )
                        ]
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30)
                            ),
                            child: SizedBox(
                                height: 4, // track height
                                child: Stack(
                                    children: [
                                        // Track
                                        Container(
                                            color: getFigmaColor(context, 'Palettes/Secondary 90')
                                        ),
                                        // Fill
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            child: AnimatedBuilder(
                                                animation: _progressAnimation,
                                                builder: (context, child) {
                                                    return FractionallySizedBox(
                                                        widthFactor: _progressAnimation.value,
                                                        child: Container(
                                                            height: double.infinity,
                                                            decoration: BoxDecoration(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/Secondary'
                                                                )
                                                            )
                                                        )
                                                    );
                                                }
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    )
                ]
            )
        );
    }
}
