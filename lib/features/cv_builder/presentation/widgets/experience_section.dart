import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;

  const ExperienceSection({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.experienceSection),
        ...experience.map((exp) {
          return Card(
            color: AppTheme.surfaceBg,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                exp.jobTitle,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${exp.company} • ${exp.duration}',
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<ExperienceModel>.from(experience)
                    ..remove(exp);
                  context.read<CVBuilderCubit>().updateField(
                    experience: newList,
                  );
                },
              ),
              onTap: () => _showExperienceDialog(context, exp),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showExperienceDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addExperience),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showExperienceDialog(BuildContext context, ExperienceModel? existing) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = existing != null;
    final jobTitleController = TextEditingController(
      text: existing?.jobTitle ?? '',
    );
    final companyController = TextEditingController(
      text: existing?.company ?? '',
    );
    final locationController = TextEditingController(
      text: existing?.location ?? '',
    );
    final durationController = TextEditingController(
      text: existing?.duration ?? '',
    );
    final descController = TextEditingController(
      text: existing?.responsibilities.join('\n') ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.editExperience : loc.addExperience,
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormDialogField(
                controller: jobTitleController,
                label: loc.jobTitleField,
              ),
              FormDialogField(
                controller: companyController,
                label: loc.companyField,
              ),
              FormDialogField(
                controller: locationController,
                label: loc.locationField,
              ),
              FormDialogField(
                controller: durationController,
                label: loc.durationField,
              ),
              FormDialogField(
                controller: descController,
                label: loc.responsibilitiesField,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              final newExp = ExperienceModel(
                jobTitle: jobTitleController.text,
                company: companyController.text,
                location: locationController.text,
                duration: durationController.text,
                responsibilities: descController.text
                    .split('\n')
                    .where((e) => e.isNotEmpty)
                    .toList(),
                description: descController.text,
                portfolioItems: [],
              );

              final cubit = context.read<CVBuilderCubit>();
              final currentList = List<ExperienceModel>.from(
                cubit.state.currentCv.experience,
              );

              if (isEditing) {
                final index = currentList.indexOf(existing);
                if (index != -1) currentList[index] = newExp;
              } else {
                currentList.add(newExp);
              }
              cubit.updateField(experience: currentList);
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
