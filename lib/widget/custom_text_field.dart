// lib/widget/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting: Tambahkan ini untuk FilteringTextInputFormatter

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String? errorText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters; // <<< BARIS BARU: Tambahkan properti ini
  final bool readOnly; // <<< BARIS BARU: Tambahkan properti readOnly
  final VoidCallback? onTap; // <<< BARIS BARU: Tambahkan properti onTap
  final int? maxLines; // <<< BARIS BARU: Tambahkan properti maxLines
  final Widget? suffixIcon; // <<< BARIS BARU: Tambahkan properti suffixIcon (jika terpisah dari onToggleVisibility)

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.errorText,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.inputFormatters, // <<< BARIS BARU: Tambahkan di konstruktor
    this.readOnly = false, // <<< BARIS BARU: Inisialisasi default
    this.onTap, // <<< BARIS BARU: Inisialisasi default
    this.maxLines = 1, // <<< BARIS BARU: Inisialisasi default
    this.suffixIcon, // <<< BARIS BARU: Inisialisasi default
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // <<< PENTING: Gunakan properti ini di TextField
      readOnly: readOnly, // <<< Gunakan properti readOnly
      onTap: onTap, // <<< Gunakan properti onTap
      maxLines: maxLines, // <<< Gunakan properti maxLines
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade50, // Warna outline saat tidak fokus
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.green.shade100, // Warna outline saat fokus
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 2,
          ),
        ),
        
        suffixIcon: onToggleVisibility != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              )
            : suffixIcon, // Jika tidak ada onToggleVisibility, gunakan suffixIcon yang lain
      ),
    );
  }
}