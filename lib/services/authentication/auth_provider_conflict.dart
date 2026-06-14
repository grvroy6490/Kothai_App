import 'package:firebase_auth/firebase_auth.dart';

/// Firebase [UserInfo.providerId] values used by [fetchSignInMethodsForEmail].
abstract final class AuthProviderIds {
  static const password = 'password';
  static const google = 'google.com';
}

/// Thrown when the user picks a sign-in method that does not match how the
/// email was originally registered.
class AuthProviderConflictException implements Exception {
  const AuthProviderConflictException({
    required this.code,
    required this.message,
    required this.existingProviders,
  });

  final String code;
  final String message;
  final List<String> existingProviders;

  FirebaseAuthException toFirebaseAuthException() {
    return FirebaseAuthException(code: code, message: message);
  }
}

/// Resolves which sign-in methods are registered for [email].
Future<List<String>> fetchSignInMethodsForEmail(
  FirebaseAuth auth,
  String email,
) async {
  final normalized = email.trim().toLowerCase();
  if (normalized.isEmpty) return const [];
  // Needed to guide users to the correct provider; may be restricted when
  // email-enumeration protection is enabled (errors are handled in AuthService).
  // ignore: deprecated_member_use
  return auth.fetchSignInMethodsForEmail(normalized);
}

bool signInMethodsIncludeGoogle(List<String> methods) {
  return methods.contains(AuthProviderIds.google);
}

bool signInMethodsIncludePassword(List<String> methods) {
  return methods.contains(AuthProviderIds.password);
}

bool signInMethodsGoogleOnly(List<String> methods) {
  return signInMethodsIncludeGoogle(methods) &&
      !signInMethodsIncludePassword(methods);
}

bool signInMethodsGoogleAndPassword(List<String> methods) {
  return signInMethodsIncludeGoogle(methods) &&
      signInMethodsIncludePassword(methods);
}

/// After email/password sign-in fails, map [methods] to a user-facing error.
///
/// When [fetchSignInMethodsForEmail] returns [] (email enumeration protection),
/// still hints that Google may be the right provider.
FirebaseAuthException emailPasswordSignInFailureException(
  List<String> methods,
) {
  if (signInMethodsGoogleOnly(methods)) {
    return FirebaseAuthException(
      code: 'account-registered-with-google',
      message:
          'This email is registered with Google. '
          'Please use Continue with Google to sign in.',
    );
  }
  if (signInMethodsGoogleAndPassword(methods)) {
    return FirebaseAuthException(
      code: 'account-linked-with-google',
      message:
          'This email is linked to Google Sign-In. '
          'If you signed in with Google before, use Continue with Google. '
          'Otherwise check your password and try again.',
    );
  }
  if (methods.isEmpty) {
    return FirebaseAuthException(
      code: 'sign-in-try-google',
      message:
          'Incorrect password. If you sign in with Google for this email, '
          'use Continue with Google instead.',
    );
  }
  return FirebaseAuthException(
    code: 'invalid-credential',
    message: 'Incorrect password. Please try again.',
  );
}

/// Email/password sign-in or sign-up when the address is Google-only.
void assertEmailPasswordAllowed(List<String> methods) {
  if (methods.isEmpty) return;
  if (signInMethodsIncludeGoogle(methods) &&
      !signInMethodsIncludePassword(methods)) {
    throw AuthProviderConflictException(
      code: 'account-registered-with-google',
      message:
          'This email is already registered with Google. '
          'Please use Continue with Google to sign in.',
      existingProviders: methods,
    ).toFirebaseAuthException();
  }
}

/// Google sign-in when the address is email/password-only.
void assertGoogleSignInAllowed(List<String> methods) {
  if (methods.isEmpty) return;
  if (signInMethodsIncludePassword(methods) &&
      !signInMethodsIncludeGoogle(methods)) {
    throw AuthProviderConflictException(
      code: 'account-registered-with-email',
      message:
          'This email is already registered with email and password. '
          'Please sign in with your email and password instead of Google.',
      existingProviders: methods,
    ).toFirebaseAuthException();
  }
}
