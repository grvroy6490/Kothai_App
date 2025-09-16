
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool _isPasswordVisible = false;
    bool _acceptTerms = false;

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text('Welcome Back', style: TextStyle(
                                                        fontSize: KxScale(context).sp(28),
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(255, 107, 114, 128)
                                                    )),
                                                Text('Login to Continue your Tamil typing journey', style: TextStyle(
                                                        fontSize: KxScale(context).sp(14),
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(255, 107, 114, 128)
                                                    ))
                                            ]
                                        )
                                    ),

                                    FilledButton(
                                        onPressed: (){
                                            Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Color.fromARGB(26, 37, 39, 44))
                                        ),
                                        child: Text('Back',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Color.fromARGB(255, 107, 114, 128)                                 )
                                        )
                                    )

                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10) ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(height: Gap(context).gap(20)),
                                    Text(
                                        'Enter password',
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: Color.fromARGB(255, 107, 114, 128),
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                    SizedBox(height: Gap(context).gap(8)),
                                    TextFormField(
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                            hintText: 'Enter your password',
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
                                            contentPadding: EdgeInsets.symmetric(horizontal: Gap(context).gap(12), vertical: Gap(context).gap(10)),
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                    color: Color.fromARGB(255, 107, 114, 128),
                                                    size: 20
                                                ),
                                                onPressed: () {
                                                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                                                }
                                            )
                                        )
                                    ),

                                    SizedBox(height: Gap(context).gap(20)),
                                    FilledButton.icon(
                                        onPressed: () {
                                            // Add your signup logic here
                                        },
                                        icon: Icon(Icons.mail_outline, color: Color.fromARGB(255, 247, 248, 248)),
                                        label: Text('Login',
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            TextButton(
                                                onPressed: () {
                                                    // Handle forgot password
                                                },
                                                child: Text('Forgot Password?',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(255, 107, 114, 128),
                                                        decoration: TextDecoration.underline
                                                    )))
                                        ]
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
                        )

                    ]
                )
            )
        );
    }
}



