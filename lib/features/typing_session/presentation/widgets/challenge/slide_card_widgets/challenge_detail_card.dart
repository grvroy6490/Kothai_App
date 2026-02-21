import 'package:flutter/material.dart';
import 'package:visai/core/config/ui/scale.dart';

class ChallengeDetailCard extends StatefulWidget {
    final double opacity;
    final double slideAngle;
    final double slideHeightMultiplier;
    final Widget? child;
    final String image;
    final bool isBlocked;

    const ChallengeDetailCard({
        super.key,
        required this.opacity,
        required this.slideAngle,
        this.slideHeightMultiplier = 0.6,
        this.child,
        this.image = 'assets/images/start_challenge_green.png',
        this.isBlocked = false
    });

    @override
    State<ChallengeDetailCard> createState() => _ChallengeDetailCardState();
}

class _ChallengeDetailCardState extends State<ChallengeDetailCard> {
    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        return AnimatedOpacity(
            opacity: widget.opacity,
            duration: Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: MediaQuery.of(context).size.width,
                height:
                MediaQuery.of(context).size.height * widget.slideHeightMultiplier,
                transform: Matrix4.rotationZ(widget.slideAngle),
                transformAlignment: Alignment.bottomCenter,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                            maxHeight: MediaQuery.of(context).size.height * 0.53
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Gap(context).gap(30),
                            horizontal: Gap(context).gap(30)
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(widget.image), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: widget.child
                    )
                )
            )
        );
    }
}
