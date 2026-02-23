import 'package:flutter/material.dart';
import 'package:seera/core/theme/app_theme.dart';

class FormTextField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const FormTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryBlue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.surfaceBg),
          ),
        ),
      ),
    );
  }
}
