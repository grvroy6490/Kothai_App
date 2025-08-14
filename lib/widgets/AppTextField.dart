import 'package:flutter/material.dart';

/// Reusable text field with optional password toggle and validation support.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.autofillHints,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.autovalidateMode,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isPwd = widget.isPassword;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: isPwd ? _obscure : false,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints,
      enabled: widget.enabled,
      maxLines: isPwd ? 1 : widget.maxLines,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 182, 186, 195),
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 216, 219, 223)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 216, 219, 223)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 216, 219, 223)),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ??
            (isPwd
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  )
                : null),
      ),
    );
  }
}
