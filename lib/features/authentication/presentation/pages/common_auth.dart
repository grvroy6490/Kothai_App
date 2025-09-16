
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/features/authentication/presentation/pages/login_page.dart';
import 'package:kothai_app/features/authentication/presentation/pages/signup_page.dart';

class CommonAuth extends StatelessWidget {
    const CommonAuth({super.key});

    @override
    Widget build(BuildContext context) {

        Future<void> _launchUrl(String url) async {
            final Uri uri = Uri.parse(url);
            // if (!await launchUrl(uri)) {
            //     // ignore: avoid_print
            //     print('Could not launch $url');
            // }
        }


        return SizedBox(
            child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 227, 228, 228),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                ),
                child: Column(
                    children: [

                        // BANNER
                        Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                                Image.asset('assets/images/auth_bg.png',
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.3

                                ),

                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: FilledButton(
                                            onPressed: (){
                                                Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                                backgroundColor: WidgetStateProperty.all(Color.fromARGB(26, 37, 39, 44))
                                            ),
                                            child: Text('Close',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Color.fromARGB(255, 107, 114, 128)                                 )
                                            )
                                        )
                                    )
                                )

                            ]
                        ),

                        // LOGIN BODY
                        Expanded(
                            child: SingleChildScrollView(
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10) ),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 247, 248, 248)
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            SizedBox(height: Gap(context).gap(20)),
                                            Text('Save your progress', style: TextStyle(
                                                    fontSize: KxScale(context).sp(20),
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 107, 114, 128)
                                                )),
                                            SizedBox(height: Gap(context).gap(20)),
                                            Text(
                                                'Enter Email Address',
                                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                    color: Color.fromARGB(255, 107, 114, 128),
                                                    fontWeight: FontWeight.w500
                                                )
                                            ),
                                            SizedBox(height: Gap(context).gap(8)),
                                            TextFormField(
                                                decoration: InputDecoration(
                                                    hintText: 'Enter your email',
                                                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Color.fromARGB(255, 182, 186, 195)
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(color: Color.fromARGB(255, 216, 219, 223))
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(color: Color.fromARGB(255, 216, 219, 223))
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: Gap(context).gap(12), vertical: Gap(context).gap(10))
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(20)),
                                            FilledButton.icon(
                                                onPressed: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: false,
                                                        builder: (BuildContext context) {
                                                            return Padding(
                                                                padding: MediaQuery.of(context).viewInsets,
                                                                child: LoginPage());
                                                        });
                                                },
                                                icon: Icon(Icons.mail_outline, color: Color.fromARGB(255, 247, 248, 248)),
                                                label: Text('Continue with email',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Color.fromARGB(255, 247, 248, 248),
                                                        fontWeight: FontWeight.w600
                                                    )
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 107, 114, 128)),
                                                    padding: WidgetStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            horizontal: Gap(context).gap(16),
                                                            vertical: Gap(context).gap(14)
                                                        )
                                                    ),
                                                    minimumSize: WidgetStateProperty.all(Size(double.infinity, 0)),
                                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                                )
                                            ),
                                            SizedBox(height: Gap(context).gap(20)),
                                            Row(
                                                children: <Widget>[
                                                    Expanded(
                                                        child: Divider(
                                                            color: Color.fromARGB(255, 216, 219, 223),
                                                            thickness: 1
                                                        )
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(8)),
                                                        child: Text("Or", style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                color: Color.fromARGB(255, 107, 114, 128)
                                                            ))
                                                    ),
                                                    Expanded(
                                                        child: Divider(
                                                            color: Color.fromARGB(255, 216, 219, 223),
                                                            thickness: 1
                                                        )
                                                    )
                                                ]
                                            ),
                                            SizedBox(height: Gap(context).gap(20)),

                                            FilledButton.icon(
                                                onPressed: () {
                                                },
                                                icon: Icon(FontAwesomeIcons.google, color: Color.fromARGB(255, 107, 114, 128)),
                                                label: Text('Continue with Google',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Color.fromARGB(255, 107, 114, 128),
                                                        fontWeight: FontWeight.w600
                                                    )
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 247, 248, 248)),
                                                    padding: WidgetStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            horizontal: Gap(context).gap(16),
                                                            vertical: Gap(context).gap(14)
                                                        )
                                                    ),
                                                    minimumSize: WidgetStateProperty.all(Size(double.infinity, 0)),
                                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            side: BorderSide(
                                                                color: Color.fromARGB(255, 107, 114, 128)
                                                            )
                                                        ))
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(20)),

                                            FilledButton.icon(
                                                onPressed: () {
                                                },
                                                icon: Icon(FontAwesomeIcons.apple, color: Color.fromARGB(255, 107, 114, 128)),
                                                label: Text('Continue with Apple',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Color.fromARGB(255, 107, 114, 128),
                                                        fontWeight: FontWeight.w600
                                                    )
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 247, 248, 248)),
                                                    padding: WidgetStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            horizontal: Gap(context).gap(16),
                                                            vertical: Gap(context).gap(14)
                                                        )
                                                    ),
                                                    minimumSize: WidgetStateProperty.all(Size(double.infinity, 0)),
                                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            side: BorderSide(
                                                                color: Color.fromARGB(255, 107, 114, 128)
                                                            )
                                                        ))
                                                )
                                            ),

                                            Divider(height: 40),

                                            Center(
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        text: 'By Continuing, you agree to the Terms of Use and Privacy Policy. கோதை is designed for educational Tamil typing practice only',
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: Color.fromARGB(255, 107, 114, 128)
                                                        )
                                                    )
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(50))

                                        ]
                                    )
                                ))
                        )
                    ]
                )
            )
        );
    }
}
