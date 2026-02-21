
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:visai/core/constants/auth_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';

// Stream of the current Firebase user; null when signed out
final authUserProvider = StreamProvider<User?>((ref) {
        // Emits on sign-in/out, token refresh, and profile changes (displayName, photoURL)
        return FirebaseAuth.instance.userChanges();
    });

// Simple boolean derived from the auth user stream
final authIsLoggedInProvider = Provider<bool>((ref) {
        final asyncUser = ref.watch(authUserProvider);
        return asyncUser.maybeWhen(
            data: (user) => user != null,
            orElse: () => false
        );
    });

// Keep SharedPreferences in sync with the current Firebase user
final authPrefsSyncProvider = Provider<void>((ref) {
        ref.listen<AsyncValue<User?>>(authUserProvider, (previous, next) {
                next.whenData((user) {
                        final prefs = ref.read(sharedPrefsServiceProvider);
                        if (user != null) {
                            // Fire and forget updates
                            prefs.setString(kcurrent_user_uid, user.uid);
                            final email = user.email;
                            if (email != null) {
                                prefs.setString(kcurrent_user_uid, email);
                            } else {
                                prefs.remove(kcurrent_user_uid);
                            }
                        } else {
                            prefs.remove(kcurrent_user_uid);
                        }
                    });
            });
    });
