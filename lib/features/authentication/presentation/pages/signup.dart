import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/constants/auth_constants.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/providers/auth/auth_provider.dart';
import 'package:kothai_app/domain/usecases/show_modal.dart';
import 'package:kothai_app/features/authentication/presentation/pages/login.dart';
import 'package:kothai_app/features/authentication/presentation/providers/auth_service_provider.dart' as auth_stream;
import 'package:kothai_app/features/authentication/presentation/widgets/form-text-field.dart';

class SignupPage extends ConsumerStatefulWidget {
    const SignupPage({super.key});

    @override
    ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {

  // 📃 DECLARATION ----------------------------
    TextEditingController _emailController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    // bool _isPasswordVisible = false;
    // bool _isConfirmPasswordVisible = false;
    bool _acceptTerms = false;
    final _formKey = GlobalKey<FormState>();

  // 🚀 METHODS --------------------------------
    void _handleLogin(){
        // Capture a stable root context before popping current sheet
        final rootCtx = Navigator.of(context, rootNavigator: true).context;
        Navigator.of(context).pop();
        Future.microtask(() {
            showAppModalBottomSheet(
                context: rootCtx,
                builder: (_) => const LoginPage(),
                heightFactor: 0.67,
                useRootNavigator: true
            );
        });
    }

    // 👇 HANDLE SIGNUP
    Future<void> _signUpWithEmailPassword(BuildContext context) async {
        if (!_formKey.currentState!.validate()) return; // Don't proceed if validation fails

        final email = _emailController.text.trim().toLowerCase();
        final password = _passwordController.text;
        final username = _usernameController.text.trim();

        // optional: simple loading overlay
        showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (_) => const Center(child: CircularProgressIndicator())
        );

        bool loaderDismissed = false;
        final messenger = ScaffoldMessenger.of(context);

        try {
            // Create account (signup), not sign-in
            await ref.read(authServiceProvider).createUserWithEmailAndPassword(email, password);

            // Persist current user to SharedPreferences
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
                if (username.isNotEmpty && user.displayName != username) {
                    await user.updateDisplayName(username);
                    await user.reload();
                }
                // TODO: Implement this
                // final prefs = ref.read(sharedPrefsServiceProvider);
                // await prefs.setString(kcurrent_user_uid, user.uid);
                // if (user.email != null) {
                //     await prefs.setString(kcurrent_user_uid, user.email!);
                // }
            }

            if (!loaderDismissed) {
                if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                }
                loaderDismissed = true;
            }

            if (!mounted) return;
            // Ensure downstream listeners rebuild with updated displayName
            ref.invalidate(auth_stream.authUserProvider);
            // Close the signup sheet (bottom sheet) after success
            Navigator.of(context).pop();
            // Notify success via captured messenger to avoid deactivated context
            messenger.showSnackBar(
                const SnackBar(content: Text('You are successfully signed up!'), backgroundColor: Colors.green)
            );
        } on FirebaseAuthException catch (e) {
            if (mounted) {
                if (!loaderDismissed) {
                    Navigator.of(context, rootNavigator: true).pop(); // close loading
                    loaderDismissed = true;
                }
                if (e.code == 'email-already-in-use') {
                    messenger.showSnackBar(
                        const SnackBar(content: Text('Account exists. Please sign in.'), backgroundColor: Colors.orange)
                    );
                    _handleLogin();
                } else {
                    final msg = switch (e.code) {
                        'weak-password' => 'Password too weak.',
                        _ => 'Sign up failed: ${e.code}'
                    };
                    messenger.showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
                }
            }
        } catch (e) {
            if (mounted) {
                if (!loaderDismissed) {
                    Navigator.of(context, rootNavigator: true).pop(); // close loading
                    loaderDismissed = true;
                }
                messenger.showSnackBar(
                    const SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red)
                );
            }
        } finally {
            if (mounted && !loaderDismissed) {
                Navigator.of(context, rootNavigator: true).pop();
                loaderDismissed = true;
            }
        }
    }

    @override
    void dispose() {
        _emailController.dispose();
        _usernameController.dispose();
        _passwordController.dispose();
        _confirmPasswordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {

        // ⭐ Widget ---------------------------------
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
                                                Text('Welcome', style: TextStyle(
                                                        fontSize: KxScale(context).sp(28),
                                                        fontWeight: FontWeight.bold,
                                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                                    )),
                                                Text('Create your Tamil typing mastery account', style: TextStyle(
                                                        fontSize: KxScale(context).sp(14),
                                                        fontWeight: FontWeight.bold,
                                                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                    ))
                                            ]
                                        )
                                    ),

                                    IconButton(
                                        onPressed: (){
                                            Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Color.fromARGB(26, 37, 39, 44)),
                                            visualDensity: VisualDensity.compact
                                        ),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(5),
                                        icon: Icon(Icons.close, color:  getFigmaColor(context, 'Schemes/On Surface'))
                                    )

                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10) ),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        SizedBox(height: Gap(context).gap(20)),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: getFigmaColor(context, 'Schemes/Surface Container Highest').withAlpha(100),
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                                border: Border(
                                                    bottom: BorderSide(color: getFigmaColor(context, 'Schemes/On Surface Variant'), width: 1.0)
                                                )
                                            ),
                                            padding: EdgeInsets.only(
                                                top: Gap(context).gap(10),
                                                left: Gap(context).gap(16),
                                                right: Gap(context).gap(16)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    _label('Enter Username'),
                                                    FormTextField(
                                                        controller: _usernameController,
                                                        hintText: 'Enter you username',
                                                        type: AuthFieldType.username
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(20)),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: getFigmaColor(context, 'Schemes/Surface Container Highest').withAlpha(100),
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                                border: Border(
                                                    bottom: BorderSide(color: getFigmaColor(context, 'Schemes/On Surface Variant'), width: 1.0)
                                                )
                                            ),
                                            padding: EdgeInsets.only(
                                                top: Gap(context).gap(10),
                                                left: Gap(context).gap(16),
                                                right: Gap(context).gap(16)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    _label('Enter Email Address'),
                                                    FormTextField(
                                                        controller: _emailController,
                                                        hintText: 'Enter you email',
                                                        type: AuthFieldType.email
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(20)),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: getFigmaColor(context, 'Schemes/Surface Container Highest').withAlpha(100),
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                                border: Border(
                                                    bottom: BorderSide(color: getFigmaColor(context, 'Schemes/On Surface Variant'), width: 1.0)
                                                )
                                            ),
                                            padding: EdgeInsets.only(
                                                top: Gap(context).gap(10),
                                                left: Gap(context).gap(16),
                                                right: Gap(context).gap(16)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    _label('Set a new password'),
                                                    FormTextField(
                                                        controller: _passwordController,
                                                        hintText: 'Enter you password',
                                                        type: AuthFieldType.password
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(20)),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: getFigmaColor(context, 'Schemes/Surface Container Highest').withAlpha(100),
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                                border: Border(
                                                    bottom: BorderSide(color: getFigmaColor(context, 'Schemes/On Surface Variant'), width: 1.0)
                                                )
                                            ),
                                            padding: EdgeInsets.only(
                                                top: Gap(context).gap(10),
                                                left: Gap(context).gap(16),
                                                right: Gap(context).gap(16)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    _label('Confirm new password'),
                                                    FormTextField(
                                                        controller: _confirmPasswordController,
                                                        hintText: 'Confirm your password',
                                                        type: AuthFieldType.passwordConfirm,
                                                        confirmWithController: _passwordController
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(20)),

                                        Row(
                                            children: [
                                                Checkbox(
                                                    value: _acceptTerms,
                                                    onChanged: (bool? value) {
                                                        setState(() {
                                                                _acceptTerms = value ?? false;
                                                            });
                                                    },
                                                    activeColor: Color.fromARGB(255, 107, 114, 128),
                                                    checkColor: Color.fromARGB(255, 247, 248, 248)
                                                ),
                                                Expanded(
                                                    child: Text('Send me learning tips & updates (Optional) Weekly Tamil typing tips and features updates',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                        )
                                                    )
                                                )
                                            ]
                                        ),

                                        SizedBox(height: Gap(context).gap(20)),

                                        FilledButton(
                                            onPressed: _acceptTerms
                                                ? () => _signUpWithEmailPassword(context)
                                                : null,
                                            style: ButtonStyle(
                                                backgroundColor: WidgetStateProperty.resolveWith((states) {
                                                        if (states.contains(WidgetState.disabled)) {
                                                            return getFigmaColor(context, 'Schemes/Primary').withAlpha(100);
                                                        }
                                                        return getFigmaColor(context, 'Schemes/Primary');
                                                    }),
                                                padding: WidgetStateProperty.all(
                                                    EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(16),
                                                        vertical: Gap(context).gap(14)
                                                    )
                                                ),
                                                minimumSize: WidgetStateProperty.all(Size(double.infinity, 0)),
                                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
                                            ),
                                            child: Text('Sign Up',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Color.fromARGB(255, 247, 248, 248),
                                                    fontWeight: FontWeight.w600
                                                )
                                            )
                                        ),
                                        SizedBox(height: Gap(context).gap(15)),
                                        Center(
                                            child: RichText(
                                                text: TextSpan(children: [
                                                        TextSpan(
                                                            text: 'Existing User? ',
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                            )
                                                        ),
                                                        TextSpan(
                                                            text: 'Login',
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: getFigmaColor(context, 'Schemes/Primary'),
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                            recognizer: TapGestureRecognizer()..onTap = () => _handleLogin()
                                                        )
                                                    ])
                                            )
                                        ),

                                        Divider(height: 40),

                                        RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Color.fromARGB(255, 107, 114, 128)
                                                ),
                                                children: <TextSpan>[
                                                    const TextSpan(text: 'By Continuing, you agree to the '),
                                                    TextSpan(
                                                        text: 'Terms of Use',
                                                        style: TextStyle(
                                                            // color: getFigmaColor(context, 'Schemes/Primary'),
                                                            decoration: TextDecoration.underline
                                                        ),
                                                        recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                            // TODO: Go To Terms Page
                                                            // launchUrl(Uri.parse('https://kothai.app/terms-of-use'));
                                                        }
                                                    ),
                                                    const TextSpan(text: ' and '),
                                                    TextSpan(
                                                        text: 'Privacy Policy',
                                                        style: TextStyle(
                                                            // color: getFigmaColor(context, 'Schemes/Primary'),
                                                            decoration: TextDecoration.underline
                                                        ),
                                                        recognizer: TapGestureRecognizer()..onTap = () => {
                                                            // TODO: Go To Policy Page
                                                        }
                                                    ),
                                                    const TextSpan(text: '. கோதை is designed for educational Tamil typing practice only.')
                                                ]
                                            )
                                        ),

                                        SizedBox(height: Gap(context).gap(50))

                                    ]
                                )
                            )
                        )

                    ]
                )
            )
        );
    }

    Widget _label(String label){
        return Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(
                    color: Color.fromARGB(255, 107, 114, 128),
                    fontWeight: FontWeight.w500
                )
        );
    }
}
