import 'package:flutter/material.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/core/ui/app_scaffold_messenger.dart';

/// Context tied to the root navigator (above login/signup bottom sheets).
BuildContext authModalOverlayContext(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).context;
}

/// Shows a snackbar above login/signup modals (app-level messenger, top-floating).
void showAuthModalSnackBar(
  BuildContext context, {
  required String message,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlayCtx = authModalOverlayContext(context);
  final size = MediaQuery.sizeOf(overlayCtx);
  final statusBar = MediaQuery.paddingOf(overlayCtx).top;
  const belowStatusBar = 36.0;
  const snackBarHeight = 56.0;
  final topEdge = statusBar + belowStatusBar;

  appScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: size.height - topEdge - snackBarHeight,
      ),
    ),
  );
}

/// Shows a clear dialog when the user picks the wrong sign-in method for an email.
Future<void> showAuthProviderConflictAlert(
  BuildContext context, {
  required String title,
  required String message,
}) {
  final overlayCtx = authModalOverlayContext(context);
  return showDialog<void>(
    context: overlayCtx,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(
            'OK',
            style: TextStyle(color: getFigmaColor(ctx, 'Schemes/Primary')),
          ),
        ),
      ],
    ),
  );
}

String authProviderConflictTitle(String code) {
  return switch (code) {
    'account-registered-with-google' => 'Use Google sign-in',
    'account-linked-with-google' => 'Google sign-in linked',
    'sign-in-try-google' => 'Try Google sign-in',
    'account-registered-with-email' => 'Use email sign-in',
    _ => 'Sign-in method mismatch',
  };
}

bool isAuthProviderConflictCode(String code) {
  return code == 'account-registered-with-google' ||
      code == 'account-registered-with-email' ||
      code == 'account-linked-with-google' ||
      code == 'sign-in-try-google';
}
