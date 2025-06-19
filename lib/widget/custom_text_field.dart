import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String? errorText;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.errorText,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            onToggleVisibility != null
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
                : null,
      ),
    );
  }
}
