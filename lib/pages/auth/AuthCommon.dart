import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:kothai_app/pages/SplashPage.dart';
import 'package:kothai_app/pages/auth/AuthBanner.dart';
import 'package:kothai_app/pages/auth/LoginPage.dart';
import 'package:kothai_app/pages/auth/SignupPage.dart';
import 'package:kothai_app/services/firebase/firebase_auth_service.dart';
import 'package:kothai_app/services/firebase/firebase_oAuth_service.dart';
import 'package:kothai_app/widgets/AppTextField.dart';

class Authcommon extends StatefulWidget {
  const Authcommon({super.key});

  @override
  State<Authcommon> createState() => _AuthcommonState();
}

class _AuthcommonState extends State<Authcommon> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showSignupPagePopup(BuildContext ctx, String email) {
    Future.microtask(() {
      showModalBottomSheet<void>(
        context: ctx,
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (_) => SignupPage(email: email), // <<< pass it here
      );
    });
  }

  void _showLoginPagePopup(BuildContext ctx, String email) {
    Future.microtask(() {
      showModalBottomSheet<void>(
        context: ctx,
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (_) => LoginPage(email: email), // (optional) do same for login

      );
    });
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
                  onTap: () {}, // Prevent tap from propagating to close
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        // keep content above keyboard
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          children: [
                            const Authbanner(),
                            _buildAuthContent(context),
                          ],
                        ),
                      ),
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

  Widget _buildAuthContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
      width: double.infinity,
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Save your progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Color.fromARGB(255, 107, 114, 128),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Enter Email Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Color.fromARGB(255, 107, 114, 128),
              ),
            ),
            const SizedBox(height: 5),

            // ✅ Email field using form_field_validator
            AppTextField(
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: _emailCtrl,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Email is required'),
                // supports plus tagging and common domains
                PatternValidator(
                  r'^[\w.\-+]+@([\w\-]+\.)+[A-Za-z]{2,}$',
                  errorText: 'Enter a valid email',
                ),
              ]),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () async {
                  final valid = _formKey.currentState?.validate() ?? false;
                  if (!valid) return;

                  final firebaseAuthService = FirebaseAuthService();
                  final email = _emailCtrl.text.trim();
                  print(email);

                  final emailExists = await firebaseAuthService.emailExists(
                    email,
                  );
                  Navigator.pop(context); // close this sheet first

                  if (emailExists) {
                    _showLoginPagePopup(context, email);
                  } else {
                    _showSignupPagePopup(context, email);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 107, 114, 128),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                icon: const Icon(Icons.email),
                label: const Text(
                  'Continue with email',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                iconAlignment: IconAlignment.start,
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.center,
              children: [
                const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                  child: const Text(
                    'or',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () async {
                  final user = await FirebaseOAuthService().signInWithGoogle();
                  if (user != null) {
                    // Sign in successful, navigate to the next screen
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    // Sign in failed, show an error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Sign in failed. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 216, 219, 223),
                      ),
                    ),
                  ),
                ),
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Color.fromARGB(255, 107, 114, 128),
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 114, 128),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                iconAlignment: IconAlignment.start,
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 216, 219, 223),
                      ),
                    ),
                  ),
                ),
                icon: const Icon(
                  FontAwesomeIcons.apple,
                  color: Color.fromARGB(255, 107, 114, 128),
                  size: 20,
                ),
                label: const Text(
                  'Continue with Apple',
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 114, 128),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                iconAlignment: IconAlignment.start,
              ),
            ),

            const SizedBox(height: 20),
            const DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Center(
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
    );
  }
}
