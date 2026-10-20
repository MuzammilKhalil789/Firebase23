import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final Color textColor;
  final Color? cursorColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? iconColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.textColor = Colors.white,
    this.cursorColor,
    this.labelColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
      ),
      cursorColor: cursorColor ?? textColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: labelColor ?? (textColor == Colors.white ? Colors.white70 : Colors.black54),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor ?? (textColor == Colors.white ? Colors.white38 : Colors.black38),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: iconColor ?? (textColor == Colors.white ? Colors.white70 : Colors.black54),
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: textColor == Colors.white
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: textColor == Colors.white
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: textColor == Colors.white
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }
}