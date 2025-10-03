import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kothai_app/services/firebase/authentication_service.dart';
import 'package:riverpod/riverpod.dart';

// Low-level dependency providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// App-level AuthService provider
final authServiceProvider = Provider<AuthService>((ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final db = ref.watch(firebaseFirestoreProvider);
    return AuthService(auth, db);
});

