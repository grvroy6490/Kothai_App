import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
    final FirebaseAuth _auth;
    final FirebaseFirestore? _db;
    // Initialize GoogleSignIn with default configuration
    // For Android, it reads from google-services.json automatically
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

    AuthService(this._auth, this._db);

    Future<UserCredential?> signInWithEmailAndPassword(
        String email,
        String password
    ) async {
        try {
            final credential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );

            return credential;
        } on FirebaseAuthException catch (e) {
            // Re-throw with more specific messages for known error codes
            if (e.code == 'user-not-found') {
                throw FirebaseAuthException(
                    code: 'user-not-found',
                    message: 'No user found for that email.'
                );
            } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
                throw FirebaseAuthException(
                    code: e.code,
                    message: 'Wrong password provided for that user.'
                );
            } else if (e.code == 'network-request-failed' ||
                e.code == 'too-many-requests' ||
                e.message?.toLowerCase().contains('network') == true ||
                e.message?.toLowerCase().contains('recaptcha') == true ||
                e.message?.toLowerCase().contains('timeout') == true) {
                // Network or reCAPTCHA related errors
                throw FirebaseAuthException(
                    code: 'network-request-failed',
                    message:
                    'Network error. Please check your internet connection and try again.'
                );
            } else {
                // Re-throw other FirebaseAuthExceptions as-is
                rethrow;
            }
        } catch (e) {
            // Catch any other exceptions and wrap them if needed
            if (e is FirebaseAuthException) {
                rethrow;
            }
            // For non-Firebase exceptions, wrap them
            throw FirebaseAuthException(
                code: 'unknown-error',
                message: 'An unexpected error occurred. Please try again.'
            );
        }
    }

    Future<void> createUserWithEmailAndPassword(
        String email,
        String password
    ) async {
        try {
            final credential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );

            final created = credential.user;
            if (created == null) {
                throw FirebaseAuthException(
                    code: 'user-null',
                    message: 'User creation failed'
                );
            }

            await _upsertUser(created);
        } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
                throw FirebaseAuthException(
                    code: 'weak-password',
                    message: 'The password provided is too weak.'
                );
            } else if (e.code == 'email-already-in-use') {
                throw FirebaseAuthException(
                    code: 'email-already-in-use',
                    message: 'The account already exists for that email.'
                );
            } else if (e.code == 'network-request-failed' ||
                e.message?.toLowerCase().contains('network') == true ||
                e.message?.toLowerCase().contains('recaptcha') == true ||
                e.message?.toLowerCase().contains('timeout') == true) {
                // Network or reCAPTCHA related errors
                throw FirebaseAuthException(
                    code: 'network-request-failed',
                    message:
                    'Network error. Please check your internet connection and try again.'
                );
            } else {
                // Re-throw other FirebaseAuthExceptions as-is
                rethrow;
            }
        } catch (e) {
            // Catch any other exceptions
            if (e is FirebaseAuthException) {
                rethrow;
            }
            print('Unexpected error creating user: $e');
            throw FirebaseAuthException(
                code: 'unknown-error',
                message: 'An unexpected error occurred. Please try again.'
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
                    message: 'Failed to retrieve ID Token for Firebase Auth.'
                );
            }

            // Create Firebase credential using both tokens
            // accessToken is optional but recommended for better security
            final AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken
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
                print("Error during Google Sign-In with Firebase Auth: $e");
            }
            rethrow;
        } catch (e) {
            if (kDebugMode) {
                print("Error during Google Sign-In: $e");
                print("Error type: ${e.runtimeType}");
            }

            // Check if it's a cancellation error
            final errorString = e.toString().toLowerCase();
            if (errorString.contains('cancel') ||
                errorString.contains('sign_in_canceled')) {
                if (kDebugMode) {
                    print("Google Sign-In was cancelled by user");
                }
                // User cancelled - return null instead of throwing
                return null;
            }

            // For other errors, throw a FirebaseAuthException
            throw FirebaseAuthException(
                code: 'google-sign-in-failed',
                message:
                'An unexpected error occurred during Google Sign-In: ${e.toString()}'
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
            'createdAt': FieldValue.serverTimestamp()
        };

        final db = _db ?? FirebaseFirestore.instance;
        await db.collection('users').doc(uid).set(data, SetOptions(merge: true));

        if (kDebugMode) {
            print('User document written for $uid');
        }
    }
}
