import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:kothai_app/pages/SplashPage.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/pages/auth/AuthBanner.dart';
import 'package:kothai_app/services/firebase/firebase_auth_service.dart';
import 'package:kothai_app/widgets/AppTextField.dart';
import 'package:dotted_line/dotted_line.dart';

class LoginPage extends StatefulWidget {
  final String email;
  const LoginPage({super.key, required this.email});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuthService().signIn(
        email: widget.email,
        password: _passwordCtrl.text,
      );
      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wrong password provided for that user.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.message}')),
        );
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // blur strength
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(204, 37, 39, 44).withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {}, // Prevent tap from propagating
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 25),
                          width: double.infinity,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: Color.fromARGB(255, 107, 114, 128),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Login to Continue your Tamil typing journey',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Color.fromARGB(255, 107, 114, 128),
                                  ),
                                ),
                                SizedBox(height: 25),

                                Text(
                                  'Enter Password',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Color.fromARGB(255, 107, 114, 128),
                                  ),
                                ),
                                SizedBox(height: 5),

                                AppTextField(
                                  hint: 'Enter your password',
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  controller: _passwordCtrl,
                                  isPassword: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                      errorText: 'Password is required',
                                    ),
                                    MinLengthValidator(
                                      8,
                                      errorText:
                                          'Password must be at least 8 characters long',
                                    ),
                                  ]),
                                ),

                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: FilledButton.icon(
                                    onPressed: _loading
                                        ? null
                                        : () async {
                                            final valid =
                                                _formKey.currentState
                                                    ?.validate() ??
                                                false;
                                            if (!valid) return;
                                            await _login();
                                          },

                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 107, 114, 128),
                                          ),
                                      shape:
                                          MaterialStateProperty.all<
                                            RoundedRectangleBorder
                                          >(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                    ),
                                    icon: const Icon(Icons.lock),
                                    label: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    iconAlignment: IconAlignment.start,
                                  ),
                                ),
                                SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Forgot your Password?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                          color: Color.fromARGB(
                                            255,
                                            107,
                                            114,
                                            128,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Colors.grey,
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    'By continuing, you agree to the Terms of Use and Privacy Policy.\n'
                                    'கோதை is designed for educational Tamil typing practice only.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                      color: Color.fromARGB(255, 107, 114, 128),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
