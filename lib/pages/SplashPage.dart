import 'package:flutter/material.dart';
import 'package:kothai_app/pages/auth/AuthCommon.dart';
import 'package:kothai_app/widgets/PageSlider.dart';

class SplashPage extends StatelessWidget {
    const SplashPage({super.key});

    void _showFullPagePopup(BuildContext context) {
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.transparent, // no dark overlay
            backgroundColor: Colors.transparent, // fully transparent background
            builder: (BuildContext context) {
                return Authcommon();
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: PageSlider(
                pages: [
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                            children: [
                                Expanded(
                                    flex: 8,
                                    child: Container(
                                        height: double.infinity,
                                        child: Image.asset(
                                            'assets/images/Kothai_logo.png',
                                            fit: BoxFit.contain,
                                            width: 150,
                                        ),
                                    ),
                                ),
                                Container(
                                    child: Text(
                                        "வணக்கம்!",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NotoSansTamil',
                                        ),
                                        textAlign: TextAlign.center,
                                    ),
                                ),
                                Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                            "கோதை செயலியில் உங்களை வரவேற்கிறோம். நீங்கள் எழுதுவது போல் தட்டச்சு செய்யலாம்.",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'NotoSansTamil',
                                                decoration: TextDecoration.none
                                            ),
                                            textAlign: TextAlign.center,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                            children: [
                                Expanded(
                                    flex: 8,
                                    child: Container(
                                        height: double.infinity,
                                        child: Image.asset(
                                            'assets/images/Kothai_logo.png',
                                            fit: BoxFit.contain,
                                            width: 150,
                                        ),
                                    ),
                                ),
                                Container(
                                    child: ElevatedButton(onPressed: (){
                                            _showFullPagePopup(context);
                                        }, child: Text("Login"))
                                ),
                            ],
                        ),
                    ),
                ],
                onFinished: () {
                    print("Page slider completed!");
                },
            ),
        );
    }
}
