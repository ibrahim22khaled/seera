import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class EducationSection extends StatelessWidget {
  final List<EducationModel> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.educationSection),
        ...education.map((edu) {
          return Card(
            color: AppTheme.surfaceBg,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                edu.degree,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                edu.institution,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<EducationModel>.from(education)
                    ..remove(edu);
                  context.read<CVBuilderCubit>().updateField(
                    education: newList,
                  );
                },
              ),
              onTap: () => _showEducationDialog(context, edu),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showEducationDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addEducation),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showEducationDialog(BuildContext context, EducationModel? existing) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = existing != null;
    final degreeController = TextEditingController(
      text: existing?.degree ?? '',
    );
    final institutionController = TextEditingController(
      text: existing?.institution ?? '',
    );
    final dateController = TextEditingController(
      text: existing?.dateRange ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.edit : loc.addEducation,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormDialogField(
              controller: degreeController,
              label: loc.degreeField,
            ),
            FormDialogField(
              controller: institutionController,
              label: loc.institutionField,
            ),
            FormDialogField(controller: dateController, label: loc.periodField),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              final newEdu = EducationModel(
                degree: degreeController.text,
                institution: institutionController.text,
                dateRange: dateController.text,
              );

              final cubit = context.read<CVBuilderCubit>();
              final currentList = List<EducationModel>.from(
                cubit.state.currentCv.education,
              );

              if (isEditing) {
                final index = currentList.indexOf(existing);
                if (index != -1) currentList[index] = newEdu;
              } else {
                currentList.add(newEdu);
              }
              cubit.updateField(education: currentList);
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
