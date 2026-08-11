import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:visai/core/constants/android_signing_fingerprints.dart';
import 'package:visai/services/authentication/auth_provider_conflict.dart';
import 'package:visai/services/notifications/push_notification_service.dart';

/// iOS OAuth client ID (reversed URL scheme in Info.plist is derived from this).
const String _kGoogleSignInIosClientId =
    '834995515353-4vv36b5krrkd219ofnj618m9277bmiva.apps.googleusercontent.com';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore? _db;
  // Initialize GoogleSignIn with web client ID for server-side authentication
  // The web client ID is required for Firebase Auth to work with Google Sign-In
  // This is the OAuth 2.0 client ID (type 3) from google-services.json
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // Use the web client ID from google-services.json for server-side authentication
    serverClientId:
        '834995515353-o2str0l8rbpfkf0gmnrejjj0eii4883k.apps.googleusercontent.com',
    // On iOS, set clientId to the iOS OAuth client so the native SDK matches Info.plist URL scheme
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? _kGoogleSignInIosClientId
        : null,
  );

  AuthService(this._auth, this._db);

  /// Validates email format
  static bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  static bool _isValidPassword(String password) {
    // Minimum 6 characters (Firebase requirement)
    return password.length >= 6;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter a valid email address.',
      );
    }

    // Validate password
    if (password.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-password',
        message: 'Please enter your password.',
      );
    }

    final normalizedEmail = email.trim().toLowerCase();

    try {
      final methods = await fetchSignInMethodsForEmail(_auth, normalizedEmail);
      assertEmailPasswordAllowed(methods);

      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth 5.7.0 error codes
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message:
                'No account found with this email address. Please sign up first.',
          );
        case 'wrong-password':
        case 'invalid-credential':
          final methods =
              await fetchSignInMethodsForEmail(_auth, normalizedEmail);
          throw emailPasswordSignInFailureException(methods);
        case 'account-registered-with-google':
        case 'account-linked-with-google':
        case 'sign-in-try-google':
          rethrow;
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Please enter a valid email address.',
          );
        case 'user-disabled':
          throw FirebaseAuthException(
            code: 'user-disabled',
            message: 'This account has been disabled. Please contact support.',
          );
        case 'too-many-requests':
          throw FirebaseAuthException(
            code: 'too-many-requests',
            message:
                'Too many failed attempts. Please try again later or reset your password.',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message:
                'Email/password sign-in is not enabled. Please contact support.',
          );
        case 'network-request-failed':
          throw FirebaseAuthException(
            code: 'network-request-failed',
            message:
                'Network error. Please check your internet connection and try again.',
          );
        default:
          // Check for network-related errors in message
          final errorMsg = e.message?.toLowerCase() ?? '';
          if (errorMsg.contains('network') ||
              errorMsg.contains('recaptcha') ||
              errorMsg.contains('timeout') ||
              errorMsg.contains('connection') ||
              errorMsg.contains('socket')) {
            throw FirebaseAuthException(
              code: 'network-request-failed',
              message:
                  'Network error. Please check your internet connection and try again.',
            );
          }
          // Re-throw with original message for unknown errors
          rethrow;
      }
    } catch (e) {
      // Catch any other exceptions
      if (e is FirebaseAuthException) {
        rethrow;
      }
      if (kDebugMode) {
        print('Unexpected error during sign in: $e');
      }
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter a valid email address.',
      );
    }

    // Validate password strength
    if (!_isValidPassword(password)) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 6 characters long.',
      );
    }

    final normalizedEmail = email.trim().toLowerCase();

    try {
      final methods = await fetchSignInMethodsForEmail(_auth, normalizedEmail);
      assertEmailPasswordAllowed(methods);

      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final created = credential.user;
      if (created == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User creation failed. Please try again.',
        );
      }

      await _upsertUser(created);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth 5.7.0 error codes
      switch (e.code) {
        case 'weak-password':
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'Password must be at least 6 characters long.',
          );
        case 'email-already-in-use':
          final methods =
              await fetchSignInMethodsForEmail(_auth, normalizedEmail);
          if (signInMethodsIncludeGoogle(methods) &&
              !signInMethodsIncludePassword(methods)) {
            throw FirebaseAuthException(
              code: 'account-registered-with-google',
              message:
                  'This email is already registered with Google. '
                  'Please use Continue with Google to sign in.',
            );
          }
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message:
                'An account already exists with this email address. Please sign in instead.',
          );
        case 'account-registered-with-google':
          rethrow;
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Please enter a valid email address.',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message:
                'Email/password sign-up is not enabled. Please contact support.',
          );
        case 'network-request-failed':
          throw FirebaseAuthException(
            code: 'network-request-failed',
            message:
                'Network error. Please check your internet connection and try again.',
          );
        default:
          // Check for network-related errors in message
          final errorMsg = e.message?.toLowerCase() ?? '';
          if (errorMsg.contains('network') ||
              errorMsg.contains('recaptcha') ||
              errorMsg.contains('timeout') ||
              errorMsg.contains('connection') ||
              errorMsg.contains('socket')) {
            throw FirebaseAuthException(
              code: 'network-request-failed',
              message:
                  'Network error. Please check your internet connection and try again.',
            );
          }
          // Re-throw with original message for unknown errors
          rethrow;
      }
    } catch (e) {
      // Catch any other exceptions
      if (e is FirebaseAuthException) {
        rethrow;
      }
      if (kDebugMode) {
        print('Unexpected error creating user: $e');
      }
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Use signIn() method for version 6.3.0
      // This opens the account picker and handles the authentication flow
      // Note: signIn() will automatically show account picker even if user is already signed in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (kDebugMode) {
          print("Google Sign-In: User cancelled or returned null");
        }
        return null; // User cancelled
      }

      // Get authentication details (idToken and accessToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message:
              'Failed to retrieve ID Token for Firebase Auth. Please try again.',
        );
      }

      final googleEmail = googleUser.email.trim().toLowerCase();
      if (googleEmail.isNotEmpty) {
        final methods = await fetchSignInMethodsForEmail(_auth, googleEmail);
        assertGoogleSignInAllowed(methods);
      }

      // Create Firebase credential using both tokens
      // accessToken is optional but recommended for better security
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Upsert user data to Firestore
      if (userCredential.user != null) {
        await _upsertUser(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(
          "Error during Google Sign-In with Firebase Auth: ${e.code} - ${e.message}",
        );
      }

      // Handle Firebase Auth 5.7.0 error codes
      switch (e.code) {
        case 'account-exists-with-different-credential':
          final pendingEmail = e.email?.trim().toLowerCase() ?? '';
          if (pendingEmail.isNotEmpty) {
            final methods =
                await fetchSignInMethodsForEmail(_auth, pendingEmail);
            if (signInMethodsIncludePassword(methods) &&
                !signInMethodsIncludeGoogle(methods)) {
              throw FirebaseAuthException(
                code: 'account-registered-with-email',
                message:
                    'This email is already registered with email and password. '
                    'Please sign in with your email and password instead of Google.',
              );
            }
            if (signInMethodsIncludeGoogle(methods) &&
                !signInMethodsIncludePassword(methods)) {
              throw FirebaseAuthException(
                code: 'account-registered-with-google',
                message:
                    'This email is already registered with Google. '
                    'Please use Continue with Google to sign in.',
              );
            }
          }
          throw FirebaseAuthException(
            code: 'account-exists-with-different-credential',
            message:
                'An account already exists with this email using a different sign-in method. '
                'Please use the method you originally signed up with.',
          );
        case 'account-registered-with-email':
        case 'account-registered-with-google':
          rethrow;
        case 'invalid-credential':
          throw FirebaseAuthException(
            code: 'invalid-credential',
            message:
                'The credential is invalid or has expired. Please try again.',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'Google Sign-In is not enabled. Please contact support.',
          );
        case 'user-disabled':
          throw FirebaseAuthException(
            code: 'user-disabled',
            message: 'This account has been disabled. Please contact support.',
          );
        case 'network-request-failed':
          throw FirebaseAuthException(
            code: 'network-request-failed',
            message:
                'Network error. Please check your internet connection and try again.',
          );
        case 'missing-id-token':
          throw FirebaseAuthException(
            code: 'missing-id-token',
            message:
                'Failed to retrieve authentication token. Please try again.',
          );
        default:
          // Check for network-related errors in message
          final errorMsg = e.message?.toLowerCase() ?? '';
          if (errorMsg.contains('network') ||
              errorMsg.contains('timeout') ||
              errorMsg.contains('connection') ||
              errorMsg.contains('socket')) {
            throw FirebaseAuthException(
              code: 'network-request-failed',
              message:
                  'Network error. Please check your internet connection and try again.',
            );
          }
          // Re-throw with original message for unknown errors
          rethrow;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }

      if (kDebugMode) {
        print("Error during Google Sign-In: $e");
        print("Error type: ${e.runtimeType}");
      }

      // Check if it's a cancellation error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancel') ||
          errorString.contains('sign_in_canceled') ||
          errorString.contains('sign_in_aborted')) {
        if (kDebugMode) {
          print("Google Sign-In was cancelled by user");
        }
        // User cancelled - return null instead of throwing
        return null;
      }

      // Android: ApiException 10 / DEVELOPER_ERROR — app SHA not registered in Firebase
      if (e is PlatformException) {
        final combined =
            '${e.message ?? ''} ${e.details ?? ''} ${e.code}'.toLowerCase();
        if ((combined.contains('10') && combined.contains('apiexception')) ||
            combined.contains('developer_error')) {
          throw FirebaseAuthException(
            code: 'google-android-config',
            message: AndroidSigningFingerprints.googleSignInShaMismatchHint,
          );
        }
      }

      // For other errors, throw a FirebaseAuthException
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message:
            'An unexpected error occurred during Google Sign-In. Please try again.',
      );
    }
  }

  Future<void> _upsertUser(User authUser) async {
    final uid = authUser.uid;

    final email = authUser.email;
    final data = <String, dynamic>{
      'uid': uid,
      'email': email,
      if (email != null) 'emailLower': email.toLowerCase(),
      'displayName': authUser.displayName,
      'phoneNumber': authUser.phoneNumber,
      'photoURL': authUser.photoURL,
      'emailVerified': authUser.emailVerified,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final db = _db ?? FirebaseFirestore.instance;
    await db.collection('users').doc(uid).set(data, SetOptions(merge: true));

    if (!kIsWeb) {
      await PushNotificationService.instance.onUserSignedIn();
    }

    if (kDebugMode) {
      print('User document written for $uid');
    }
  }
}
