import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/android_signing_fingerprints.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/di/providers/auth/auth_provider.dart';
import 'package:visai/domain/usecases/show_modal.dart';
import 'package:visai/features/authentication/presentation/pages/signup.dart';
import 'package:visai/features/authentication/presentation/widgets/auth_provider_alert.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends ConsumerStatefulWidget {
    const LoginPage({super.key});

    @override
    ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
    // 📃 DECLARATION ----------------------------

    bool _isPasswordVisible = false;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final FocusNode _focusNode = FocusNode();
    final FocusNode _passwordFocusNode = FocusNode();
    final _formloginKey = GlobalKey<FormState>();
    String? _passwordError;
    bool _loggingIn = false;

    // 🚀 METHODS --------------------------------
    void _handleSignup() {
        final rootCtx = Navigator.of(context, rootNavigator: true).context;
        Navigator.of(context).pop();
        Future.microtask(() {
                showAppModalWithChild(
                    context: rootCtx,
                    child: const SignupPage(),
                    heightFactor: 0.84,
                    useRootNavigator: true
                );
            });
    }

    Future<void> _syncGuestProgressAfterLogin() async {
        try {
            await ref.read(scoreControllerProvider.notifier).syncAll();
            if (!mounted) return;
            showAuthModalSnackBar(
                context,
                message: 'Logged in — your progress was saved to the cloud.',
                backgroundColor: Colors.green,
            );
        } catch (e) {
            if (!mounted) return;
            showAuthModalSnackBar(
                context,
                message: 'Logged in, but sync failed: $e. Use Profile → Save progress.',
                backgroundColor: Colors.orange,
            );
        }
    }

    // 👇 HANDLE LOGIN
    Future<void> _loginWithEmailAndPassword() async {
        if (!_formloginKey.currentState!.validate()) return;

        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');

        // Show loading while checking the account
        setState(() => _loggingIn = true);
        showDialog(
            context: authModalOverlayContext(context),
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (_) => const Center(child: CircularProgressIndicator())
        );

        bool loaderDismissed = false;
        final email = _emailController.text.trim().toLowerCase();
        final password = _passwordController.text;

        try {

            final credential = await ref
                .read(authServiceProvider)
                .signInWithEmailAndPassword(email, password);

            // Verify user is actually signed in
            if (credential?.user == null) {
                throw FirebaseAuthException(
                    code: 'user-null',
                    message: 'Sign in succeeded but user is null'
                );
            }

            // Verify the current user is set (should be available immediately after sign-in)
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
                // If user is not immediately available, wait a bit for Firebase Auth to sync
                await Future.delayed(const Duration(milliseconds: 300));
                final retryUser = FirebaseAuth.instance.currentUser;
                if (retryUser == null) {
                    throw FirebaseAuthException(
                        code: 'auth-state-sync',
                        message: 'User signed in but auth state not synced'
                    );
                }
            }

            // Close the loading dialog attached to root navigator
            if (!loaderDismissed) {
                if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                }
                loaderDismissed = true;
            }

            if (!mounted) return;

            // Close the login bottom sheet
            Navigator.of(context).pop();

            try {
                await ref.read(scoreControllerProvider.notifier).syncAll();
                if (!mounted) return;
                showAuthModalSnackBar(
                    context,
                    message: 'Logged in — your progress was saved to the cloud.',
                    backgroundColor: Colors.green,
                );
            } catch (e) {
                if (!mounted) return;
                showAuthModalSnackBar(
                    context,
                    message: 'Logged in, but sync failed: $e. Use Profile → Save progress.',
                    backgroundColor: Colors.orange,
                );
            }

            return;
        } catch (e) {
            if (mounted) {
                if (!loaderDismissed) {
                    Navigator.of(context, rootNavigator: true).pop();
                    loaderDismissed = true;
                }
                String? fieldError;
                String? snack;
                if (e is FirebaseAuthException) {
                    if (isAuthProviderConflictCode(e.code)) {
                        if (!mounted) return;
                        setState(() => _passwordError = null);
                        await showAuthProviderConflictAlert(
                            context,
                            title: authProviderConflictTitle(e.code),
                            message: e.message ??
                                'Please use the sign-in method you originally registered with.',
                        );
                    } else {
                    switch (e.code) {
                        case 'wrong-password':
                        case 'invalid-credential':
                            fieldError = e.message ??
                                'Incorrect password. Please try again.';
                            break;
                        case 'user-not-found':
                            fieldError = 'Incorrect email or password.';
                            break;
                        case 'too-many-requests':
                            snack = 'Too many attempts. Please try again later.';
                            break;
                        case 'network-request-failed':
                        case 'network-error':
                            snack =
                            'Network error. Please check your internet connection and try again.';
                            break;
                        case 'user-null':
                        case 'auth-state-sync':
                            snack = 'Authentication error. Please try again.';
                            break;
                        default:
                        // Check if the error message contains network-related keywords
                        final errorMsg = e.message?.toLowerCase() ?? '';
                        if (errorMsg.contains('network') ||
                            errorMsg.contains('recaptcha') ||
                            errorMsg.contains('timeout') ||
                            errorMsg.contains('connection')) {
                            snack =
                            'Network error. Please check your internet connection and try again.';
                        } else {
                            snack = e.message ?? 'Sign in failed. Please try again.';
                        }
                    }
                    }
                } else {
                    // Handle non-Firebase exceptions
                    final errorStr = e.toString().toLowerCase();
                    if (errorStr.contains('network') ||
                        errorStr.contains('socket') ||
                        errorStr.contains('timeout') ||
                        errorStr.contains('connection')) {
                        snack =
                        'Network error. Please check your internet connection and try again.';
                    } else {
                        snack = 'Unexpected error. Please try again.';
                    }
                }

                if (fieldError != null) {
                    setState(() {
                            _passwordError = fieldError;
                        });
                    _formloginKey.currentState?.validate();
                    _passwordFocusNode.requestFocus();
                }
                if (snack != null) {
                    showAuthModalSnackBar(
                        context,
                        message: snack,
                        backgroundColor: Colors.red,
                    );
                }
            }
        } finally {
            if (mounted && !loaderDismissed) {
                Navigator.of(context, rootNavigator: true).pop();
            }
            if (mounted) setState(() => _loggingIn = false);
        }
    }

    // LOGIN WITH GOOGLE
    Future<void> _loginWithGoogle() async {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');

        // Show loading while authenticating
        setState(() => _loggingIn = true);
        showDialog(
            context: authModalOverlayContext(context),
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (_) => const Center(child: CircularProgressIndicator())
        );

        bool loaderDismissed = false;

        try {
            final credential = await ref.read(authServiceProvider).signInWithGoogle();

            if (credential == null) {
                if (mounted && !loaderDismissed) {
                    Navigator.of(context, rootNavigator: true).pop();
                    loaderDismissed = true;
                }
                if (mounted) setState(() => _loggingIn = false);
                return;
            }

            // Verify user is actually signed in
            if (credential.user == null) {
                throw FirebaseAuthException(
                    code: 'user-null',
                    message: 'Google sign in succeeded but user is null'
                );
            }

            // Verify the current user is set (should be available immediately after sign-in)
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
                // If user is not immediately available, wait a bit for Firebase Auth to sync
                await Future.delayed(const Duration(milliseconds: 300));
                final retryUser = FirebaseAuth.instance.currentUser;
                if (retryUser == null) {
                    throw FirebaseAuthException(
                        code: 'auth-state-sync',
                        message: 'User signed in but auth state not synced'
                    );
                }
            }

            // Close the loading dialog attached to root navigator
            if (!loaderDismissed) {
                if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                }
                loaderDismissed = true;
            }

            if (!mounted) return;

            Navigator.of(context).pop();
            await _syncGuestProgressAfterLogin();
            return;
        } catch (e, stackTrace) {
            if (kDebugMode) {
                debugPrint('Google sign-in error: $e (${e.runtimeType})');
                debugPrint('$stackTrace');
            }
            if (mounted) {
                if (!loaderDismissed) {
                    Navigator.of(context, rootNavigator: true).pop();
                    loaderDismissed = true;
                }
                String? snack = 'Unexpected error. Please try again.';
                var showSnack = true;
                if (e is FirebaseAuthException) {
                    if (isAuthProviderConflictCode(e.code)) {
                        showSnack = false;
                        if (!mounted) return;
                        await showAuthProviderConflictAlert(
                            context,
                            title: authProviderConflictTitle(e.code),
                            message: e.message ??
                                'Please use the sign-in method you originally registered with.',
                        );
                    } else {
                    switch (e.code) {
                        case 'account-exists-with-different-credential':
                            snack =
                            'An account already exists with the same email address but different sign-in method.';
                            break;
                        case 'network-request-failed':
                        case 'network-error':
                            snack =
                            'Network error. Please check your internet connection and try again.';
                            break;
                        case 'user-null':
                        case 'auth-state-sync':
                            snack = 'Authentication error. Please try again.';
                            break;
                        case 'google-android-config':
                            snack = AndroidSigningFingerprints.googleSignInShaMismatchHint;
                            break;
                        default:
                        // Check if the error message contains network-related keywords
                        final errorMsg = e.message?.toLowerCase() ?? '';
                        if (errorMsg.contains('network') ||
                            errorMsg.contains('recaptcha') ||
                            errorMsg.contains('timeout') ||
                            errorMsg.contains('connection')) {
                            snack =
                            'Network error. Please check your internet connection and try again.';
                        } else {
                            snack = e.message ?? 'Google sign in failed. Please try again.';
                        }
                    }
                    }
                } else if (e is FirebaseException) {
                    // e.g. Firestore write after successful Google auth
                    snack = e.code == 'permission-denied'
                        ? 'Signed in, but saving your profile was blocked. Check Firestore security rules.'
                        : 'Could not finish sign-in (${e.code}). Please try again.';
                } else if (e is PlatformException) {
                    final m = '${e.message ?? ''} ${e.code}'.toLowerCase();
                    if ((m.contains('10') && m.contains('apiexception')) ||
                        m.contains('developer_error')) {
                        snack = AndroidSigningFingerprints.googleSignInShaMismatchHint;
                    } else {
                        snack = e.message ?? 'Google sign in failed. Please try again.';
                    }
                } else {
                    // Handle non-Firebase exceptions
                    final errorStr = e.toString().toLowerCase();
                    if (errorStr.contains('network') ||
                        errorStr.contains('socket') ||
                        errorStr.contains('timeout') ||
                        errorStr.contains('connection')) {
                        snack =
                            'Network error. Please check your internet connection and try again.';
                    } else {
                        snack = kDebugMode
                            ? 'Unexpected: $e'
                            : 'Unexpected error. Please try again.';
                    }
                }

                if (showSnack && mounted) {
                    showAuthModalSnackBar(
                        context,
                        message: snack,
                        backgroundColor: Colors.red,
                        duration: snack.length > 120
                            ? const Duration(seconds: 8)
                            : const Duration(seconds: 4),
                    );
                }
            }
        } finally {
            if (mounted && !loaderDismissed) {
                Navigator.of(context, rootNavigator: true).pop();
            }
            if (mounted) setState(() => _loggingIn = false);
        }
    }

    @override
    void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        _focusNode.dispose();
        _passwordFocusNode.dispose();
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
                                                Text(
                                                    'Welcome Back',
                                                    style: TextStyle(
                                                        fontSize: KxScale(context).sp(28),
                                                        fontWeight: FontWeight.bold,
                                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                                    )
                                                ),
                                                Text(
                                                    'Login to Continue your Tamil typing journey',
                                                    style: TextStyle(
                                                        fontSize: KxScale(context).sp(14),
                                                        fontWeight: FontWeight.bold,
                                                        color: getFigmaColor(
                                                            context,
                                                            'Schemes/On Surface Variant'
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    IconButton(
                                        onPressed: () {
                                            Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(
                                                Color.fromARGB(26, 37, 39, 44)
                                            ),
                                            visualDensity: VisualDensity.compact
                                        ),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(5),
                                        icon: Icon(
                                            Icons.close,
                                            color: getFigmaColor(context, 'Schemes/On Surface')
                                        )
                                    )
                                ]
                            )
                        ),

                        // FORM AREA
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gap(context).gap(16),
                                vertical: Gap(context).gap(10)
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(height: Gap(context).gap(20)),
                                    Form(
                                        key: _formloginKey,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(
                                                            context,
                                                            'Schemes/Surface Container Highest'
                                                        ).withAlpha(100),
                                                        borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(4)
                                                        ),
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/On Surface Variant'
                                                                ),
                                                                width: 1.0
                                                            )
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
                                                            Text(
                                                                'Email Address',
                                                                style: Theme.of(context).textTheme.labelMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Surface Variant'
                                                                        ),
                                                                        fontWeight: FontWeight.w500
                                                                    )
                                                            ),
                                                            TextFormField(
                                                                controller: _emailController,
                                                                focusNode: _focusNode,
                                                                validator: (value) {
                                                                    if (value == null || value.isEmpty) {
                                                                        return 'Please enter your email';
                                                                    }
                                                                    if (!RegExp(
                                                                        r'^[^@]+@[^@]+\.[^@]+'
                                                                    ).hasMatch(value)) {
                                                                        return 'Please enter a valid email address';
                                                                    }
                                                                    return null;
                                                                },
                                                                style: Theme.of(context).textTheme.titleMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Surface'
                                                                        ),
                                                                        fontWeight: FontWeight.w500
                                                                    ),
                                                                decoration: InputDecoration(
                                                                    hintText: 'Enter your email',
                                                                    hintStyle: Theme.of(context)
                                                                        .textTheme
                                                                        .titleMedium
                                                                        ?.copyWith(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                182,
                                                                                186,
                                                                                195
                                                                            )
                                                                        ),
                                                                    border: InputBorder.none,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal: Gap(context).gap(0),
                                                                        vertical: Gap(context).gap(10)
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                                ),

                                                SizedBox(height: Gap(context).gap(20)),

                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(
                                                            context,
                                                            'Schemes/Surface Container Highest'
                                                        ).withAlpha(100),
                                                        borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(4)
                                                        ),
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/On Surface Variant'
                                                                ),
                                                                width: 1.0
                                                            )
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
                                                            Text(
                                                                'Enter password',
                                                                style: Theme.of(context).textTheme.labelMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Surface Variant'
                                                                        ),
                                                                        fontWeight: FontWeight.w500
                                                                    )
                                                            ),
                                                            TextFormField(
                                                                obscureText: !_isPasswordVisible,
                                                                controller: _passwordController,
                                                                focusNode: _passwordFocusNode,
                                                                autovalidateMode:
                                                                AutovalidateMode.onUserInteraction,
                                                                validator: (value) {
                                                                    if (value == null || value.isEmpty) {
                                                                        return 'Please enter your password';
                                                                    }
                                                                    if (_passwordError != null) {
                                                                        return _passwordError;
                                                                    }
                                                                    return null;
                                                                },
                                                                onChanged: (_) {
                                                                    if (_passwordError != null) {
                                                                        setState(() {
                                                                                _passwordError = null;
                                                                            });
                                                                    }
                                                                },
                                                                style: Theme.of(context).textTheme.titleMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Surface'
                                                                        ),
                                                                        fontWeight: FontWeight.w500
                                                                    ),
                                                                decoration: InputDecoration(
                                                                    hintText: 'Enter your password',
                                                                    hintStyle: Theme.of(context)
                                                                        .textTheme
                                                                        .titleMedium
                                                                        ?.copyWith(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                182,
                                                                                186,
                                                                                195
                                                                            )
                                                                        ),

                                                                    border: InputBorder.none,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal: Gap(context).gap(0),
                                                                        vertical: Gap(context).gap(12)
                                                                    ),
                                                                    suffixIcon: IconButton(
                                                                        icon: Icon(
                                                                            _isPasswordVisible
                                                                                ? Icons.visibility_outlined
                                                                                : Icons.visibility_off_outlined,
                                                                            color: Color.fromARGB(255, 107, 114, 128),
                                                                            size: 18
                                                                        ),
                                                                        onPressed: () {
                                                                            setState(
                                                                                () => _isPasswordVisible =
                                                                                !_isPasswordVisible
                                                                            );
                                                                        }
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    SizedBox(height: Gap(context).gap(20)),
                                    FilledButton(
                                        onPressed: _loggingIn
                                            ? null
                                            : () => _loginWithEmailAndPassword(),
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(
                                                getFigmaColor(context, 'Schemes/Primary')
                                            ),
                                            padding: WidgetStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(16),
                                                    vertical: Gap(context).gap(16)
                                                )
                                            ),
                                            minimumSize: WidgetStateProperty.all(
                                                Size(double.infinity, 0)
                                            ),
                                            shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25)
                                                )
                                            )
                                        ),
                                        child: Text(
                                            'Login',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: getFigmaColor(
                                                  context,
                                                  'Schemes/On Primary',
                                                ),
                                                fontWeight: FontWeight.w600
                                            )
                                        )
                                    ),
                                    SizedBox(height: Gap(context).gap(20)),

                                    Center(
                                        child: RichText(
                                            text: TextSpan(
                                                children: [
                                                    TextSpan(
                                                        text: 'New User? ',
                                                        style: Theme.of(context).textTheme.bodyMedium
                                                            ?.copyWith(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/On Surface Variant'
                                                                )
                                                            )
                                                    ),
                                                    TextSpan(
                                                        text: 'Signup',
                                                        style: Theme.of(context).textTheme.bodyMedium
                                                            ?.copyWith(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/Primary'
                                                                ),
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                        recognizer: TapGestureRecognizer()
                                                            ..onTap = () => _handleSignup()
                                                    )
                                                ]
                                            )
                                        )
                                    ),

                                    SizedBox(height: Gap(context).gap(20)),

                                    SizedBox(
                                        width: double.infinity,
                                        child: SignInButton(
                                            Buttons.google,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Gap(context).gap(20),
                                                vertical: Gap(context).gap(5)
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25)
                                            ),
                                            onPressed: () => _loginWithGoogle()
                                        )
                                    ),

                                    // Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //         TextButton(
                                    //             onPressed: () {
                                    //                 // Handle forgot password
                                    //             },
                                    //             child: Text('Forgot Password?',
                                    //                 style: TextStyle(
                                    //                     color: Color.fromARGB(255, 107, 114, 128),
                                    //                     decoration: TextDecoration.underline
                                    //                 )))
                                    //     ]
                                    // ),
                                    Divider(height: 40),

                                    RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Color.fromARGB(255, 107, 114, 128)
                                            ),
                                            children: <TextSpan>[
                                                const TextSpan(
                                                    text: 'By Continuing, you agree to the '
                                                ),
                                                TextSpan(
                                                    text: 'Terms of Use',
                                                    style: TextStyle(
                                                        // color: getFigmaColor(context, 'Schemes/Primary'),
                                                        decoration: TextDecoration.underline
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                        ..onTap = () async {
                                                        final uri = Uri.parse(
                                                            'https://kothai.org/policies/terms-of-service',
                                                        );
                                                        await launchUrl(
                                                            uri,
                                                            mode: LaunchMode.externalApplication,
                                                        );
                                                    }
                                                ),
                                                const TextSpan(text: ' and '),
                                                TextSpan(
                                                    text: 'Privacy Policy',
                                                    style: TextStyle(
                                                        // color: getFigmaColor(context, 'Schemes/Primary'),
                                                        decoration: TextDecoration.underline
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                        ..onTap = () async {
                                                        final uri = Uri.parse(
                                                            'https://kothai.org/policies/privacy-policy',
                                                        );
                                                        await launchUrl(
                                                            uri,
                                                            mode: LaunchMode.externalApplication,
                                                        );
                                                    }
                                                ),
                                                const TextSpan(
                                                    text:
                                                    '. விசை is designed for educational Tamil typing practice only.'
                                                )
                                            ]
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
