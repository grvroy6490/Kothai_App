
import 'package:flutter/material.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

/// A reusable text form field for authentication flows.
/// Supports email, username, password, and confirm-password with sensible defaults.
class FormTextField extends StatefulWidget {
    const FormTextField({
        super.key,
        required this.controller,
        this.type = AuthFieldType.custom,
        this.label,
        this.hintText,
        this.focusNode,
        this.textInputAction,
        this.enabled = true,
        this.autovalidateMode = AutovalidateMode.onUserInteraction,
        this.validator,
        this.onChanged,
        this.prefixIcon,
        this.suffixIcon,
        this.confirmWithController,
        this.requireSymbolInPassword = true,
        this.keyboardType,
        this.autofillHints
    });

    final TextEditingController controller;
    final AuthFieldType type;
    final String? label;
    final String? hintText;
    final FocusNode? focusNode;
    final TextInputAction? textInputAction;
    final bool enabled;
    final AutovalidateMode autovalidateMode;
    final String? Function(String?)? validator;
    final ValueChanged<String>? onChanged;
    final Widget? prefixIcon;
    final Widget? suffixIcon;
    final TextEditingController? confirmWithController; // for password confirmation
    final bool requireSymbolInPassword;
    final TextInputType? keyboardType;
    final Iterable<String>? autofillHints;

    @override
    State<FormTextField> createState() => _FormTextFieldState();
}

enum AuthFieldType {
    email, username, password, passwordConfirm, custom
}

class _FormTextFieldState extends State<FormTextField> {
    bool _obscure = false;

    @override
    void initState() {
        super.initState();
        _obscure = widget.type == AuthFieldType.password || widget.type == AuthFieldType.passwordConfirm;
    }

    TextInputType _effectiveKeyboardType() {
        if (widget.keyboardType != null) return widget.keyboardType!;
        switch (widget.type) {
            case AuthFieldType.email:
                return TextInputType.emailAddress;
            case AuthFieldType.username:
                return TextInputType.text;
            case AuthFieldType.password:
            case AuthFieldType.passwordConfirm:
                return TextInputType.visiblePassword;
            case AuthFieldType.custom:
                return TextInputType.text;
        }
    }

    Iterable<String>? _effectiveAutofillHints() {
        if (widget.autofillHints != null) return widget.autofillHints;
        switch (widget.type) {
            case AuthFieldType.email:
                return const [AutofillHints.email];
            case AuthFieldType.username:
                return const [AutofillHints.username];
            case AuthFieldType.password:
                return const [AutofillHints.password];
            case AuthFieldType.passwordConfirm:
                return const [AutofillHints.newPassword];
            case AuthFieldType.custom:
                return null;
        }
    }

    String? _defaultValidator(String? value) {
        final v = value?.trim() ?? '';
        switch (widget.type) {
            case AuthFieldType.email:
                if (v.isEmpty) return 'Please enter your email';
                final emailRe = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                if (!emailRe.hasMatch(v)) return 'Please enter a valid email address';
                return null;
            case AuthFieldType.username:
                if (v.isEmpty) return 'Please enter a username';
                final re = RegExp(r'^[a-zA-Z0-9_\.]{3,20}$');
                if (!re.hasMatch(v)) return '3–20 chars: letters, numbers, _ or .';
                return null;
            case AuthFieldType.password:
                if (v.isEmpty) return 'Please enter your password';
                if (v.length < 8) return 'Password must be at least 8 characters';
                if (!RegExp(r'[A-Za-z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
                    return 'Include letters and numbers';
                }
                if (widget.requireSymbolInPassword && !RegExp(r'[@#\$!%*?&]').hasMatch(v)) {
                    return 'Include at least one symbol';
                }
                return null;
            case AuthFieldType.passwordConfirm:
                if (v.isEmpty) return 'Please confirm your password';
                final base = widget.confirmWithController?.text ?? '';
                if (v != base) return 'Passwords do not match';
                return null;
            case AuthFieldType.custom:
                return null;
        }
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        final decoration = InputDecoration(
            hintText: widget.hintText,
            hintStyle: theme.textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 182, 186, 195)
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.type == AuthFieldType.password || widget.type == AuthFieldType.passwordConfirm
                ? IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color.fromARGB(255, 107, 114, 128),
                        size: 20
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure)
                )
                : widget.suffixIcon
        );

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                if (widget.label != null) ...[
                    Text(
                        widget.label!,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color.fromARGB(255, 107, 114, 128),
                            fontWeight: FontWeight.w500
                        )
                    ),
                    const SizedBox(height: 8)
                ],
                TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    enabled: widget.enabled,
                    autovalidateMode: widget.autovalidateMode,
                    validator: widget.validator ?? _defaultValidator,
                    onChanged: widget.onChanged,
                    obscureText: _obscure,
                    keyboardType: _effectiveKeyboardType(),
                    textInputAction: widget.textInputAction,
                    autofillHints: _effectiveAutofillHints(),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface'),
                            fontWeight: FontWeight.w500
                        ),
                    decoration: decoration
                )
            ]
        );
    }
}
