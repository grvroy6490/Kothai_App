import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    /// True if the email is already registered in Firebase Auth
    Future<bool> emailExists(String email) async {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.trim())
            .get();

        return querySnapshot.docs.isNotEmpty;
    }

    /// Create account and (optionally) create a user doc after sign-up
    Future<UserCredential> signUp({
        required String email,
        required String password
    }) async {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password
        );
        await _ensureUserDoc(
            cred.user
        ); // remove if you don’t keep a users collection
        return cred;
    }

    /// Sign in
    Future<UserCredential> signIn({
        required String email,
        required String password
    }) {
        return _auth.signInWithEmailAndPassword(
            email: email.trim(),
            password: password
        );
    }

    Future<void> signOut() async {
        await _auth.signOut();
    }

    /// Send reset email
    Future<void> sendReset(String email) =>
    _auth.sendPasswordResetEmail(email: email.trim());

    /// Create a users/{uid} doc once the user is authenticated
    Future<void> _ensureUserDoc(User? user) async {
        if (user == null) return;
        final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final snap = await doc.get();
        if (!snap.exists) {
            await doc.set({
                'email': user.email,
                'createdAt': FieldValue.serverTimestamp()
            });
        }
    }
}
