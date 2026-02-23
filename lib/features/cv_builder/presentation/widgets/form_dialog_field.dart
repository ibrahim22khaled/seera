import 'package:flutter/material.dart';
import 'package:seera/core/theme/app_theme.dart';

class FormDialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final int maxLines;

  const FormDialogField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
