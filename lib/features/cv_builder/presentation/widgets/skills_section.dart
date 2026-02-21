import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.skillsSection),
        Wrap(
          spacing: 8,
          children: skills
              .map(
                (skill) => Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppTheme.surfaceBg,
                  deleteIconColor: Colors.redAccent,
                  onDeleted: () {
                    final newList = List<String>.from(skills)..remove(skill);
                    context.read<CVBuilderCubit>().updateField(skills: newList);
                  },
                ),
              )
              .toList(),
        ),
        TextButton.icon(
          onPressed: () => _showSkillDialog(context),
          icon: const Icon(Icons.add),
          label: Text(loc.addSkill),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showSkillDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(loc.addSkill, style: const TextStyle(color: Colors.white)),
        content: FormDialogField(
          controller: controller,
          label: loc.skillsSection,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final cubit = context.read<CVBuilderCubit>();
                final currentList = List<String>.from(
                  cubit.state.currentCv.skills,
                );
                currentList.add(controller.text);
                cubit.updateField(skills: currentList);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(loc.add),
          ),
        ],
      ),
    );
  }
}
