import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/pages/practiceEditor/FooterNavigation/FooterButton.dart';


Widget FooterNav(BuildContext context){
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: 0,
            bottom: 10,
            left: 16,
            right: 16,
        ),
        decoration: BoxDecoration(
            color: Colors.transparent,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 6,
            children: [
                Expanded(
                    child: FooterNavButton(
                        label: "Practice",
                        icon: FontAwesomeIcons.keyboard,
                        onPressed: () {
                            // Handle Home button press
                        },
                        isActive: true,
                        context: context
                    ),
                ),

                Expanded(
                    child: FooterNavButton(
                        label: "Challenge",
                        icon: FontAwesomeIcons.trophy,
                        onPressed: () {
                            // Handle Home button press
                        },
                        context: context
                    ),
                ),

                Expanded(
                    child: FooterNavButton(
                        label: "Profile",
                        icon: FontAwesomeIcons.circleUser,
                        onPressed: () {
                            // Handle Home button press
                        },
                        context: context
                    ),
                ),

                Expanded(
                    child: FooterNavButton(
                        label: "More",
                        icon: FontAwesomeIcons.grip,
                        onPressed: () {
                            // Handle Home button press
                        },
                        context: context
                    ),
                ),
            ],
        ),
    );
}