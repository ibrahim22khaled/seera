import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.projectsSection),
        ...projects.map((proj) {
          return Card(
            color: AppTheme.surfaceBg,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                proj.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                proj.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<ProjectModel>.from(projects)
                    ..remove(proj);
                  context.read<CVBuilderCubit>().updateField(projects: newList);
                },
              ),
              onTap: () => _showProjectDialog(context, proj),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showProjectDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addProject),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showProjectDialog(BuildContext context, ProjectModel? existing) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    final roleController = TextEditingController(text: existing?.role ?? '');
    final linkController = TextEditingController(text: existing?.url ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.edit : loc.addProject,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormDialogField(controller: titleController, label: loc.titleField),
            FormDialogField(
              controller: descController,
              label: loc.projectDescription,
              maxLines: 3,
            ),
            FormDialogField(controller: roleController, label: loc.projectRole),
            FormDialogField(controller: linkController, label: loc.linkField),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              final newProj = ProjectModel(
                title: titleController.text,
                role: roleController.text,
                description: descController.text,
                url: linkController.text,
              );

              final cubit = context.read<CVBuilderCubit>();
              final currentList = List<ProjectModel>.from(
                cubit.state.currentCv.projects,
              );

              if (isEditing) {
                final index = currentList.indexOf(existing);
                if (index != -1) currentList[index] = newProj;
              } else {
                currentList.add(newProj);
              }
              cubit.updateField(projects: currentList);
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
