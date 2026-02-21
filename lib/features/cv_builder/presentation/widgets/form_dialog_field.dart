import 'package:flutter/material.dart';
import 'package:seera/core/theme/app_theme.dart';

class FormDialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const FormDialogField({
    super.key,
    required this.controller,
    required this.label,
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
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          filled: true,
          fillColor: AppTheme.surfaceBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.primaryBlue),
          ),
        ),
      ),
    );
  }
}
