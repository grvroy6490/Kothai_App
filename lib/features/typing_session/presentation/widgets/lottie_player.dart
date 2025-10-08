
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottiePlayer extends StatefulWidget {
    final String asset;
    final bool repeat;
    const LottiePlayer({
        super.key, 
        required this.asset,
        this.repeat = false
    });

    @override
    State<LottiePlayer> createState() => _LottiePlayerState();
}

class _LottiePlayerState extends State<LottiePlayer> with SingleTickerProviderStateMixin {
    late final AnimationController _controller;

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(vsync: this);
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Lottie.asset(
            widget.asset,
            controller: _controller,
            onLoaded: (composition) {
                _controller
                    ..duration = composition.duration
                ..forward().whenComplete(() {
                        if (widget.repeat) {
                            _controller.repeat();
                        }
                    });
            },
            repeat: widget.repeat, // ensure it doesn’t loop, controller handles repeating
            animate: widget.repeat,
            fit: BoxFit.contain
        );
    }
}
