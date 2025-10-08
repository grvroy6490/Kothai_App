import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
    final FirebaseAuth _auth;
    final FirebaseFirestore? _db;

    AuthService(this._auth, this._db);

    Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
        try {
            final credential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );

            return credential;
        } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
                throw FirebaseAuthException(code: 'user-not-found', message: 'No user found for that email.');
            } else if (e.code == 'wrong-password') {
                throw FirebaseAuthException(code: 'wrong-password', message: 'Wrong password provided for that user.');
            }
        }

        return null;
    }

    Future<void> createUserWithEmailAndPassword(String email, String password) async {
        try {
            final credential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );

            final created = credential.user;
            if (created == null) {
                throw FirebaseAuthException(code: 'user-null', message: 'User creation failed');
            }

            await _upsertUser(created);
        } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
                throw FirebaseAuthException(code: 'weak-password', message: 'The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
                throw FirebaseAuthException(code: 'email-already-in-use', message: 'The account already exists for that email.');
            } else {
                throw FirebaseAuthException(code: "other", message: 'Auth error: ${e.code} ${e.message}');
            }
            rethrow;
        } catch (e) {
            print('Unexpected error creating user: $e');
            rethrow;
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


