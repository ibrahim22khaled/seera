import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class CustomSectionsWidget extends StatelessWidget {
  final List<CustomSectionModel> sections;

  const CustomSectionsWidget({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.customSections),
        ...sections.map((section) {
          return Card(
            color: AppTheme.surfaceBg,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                section.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                section.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<CustomSectionModel>.from(sections)
                    ..remove(section);
                  context.read<CVBuilderCubit>().updateField(
                    customSections: newList,
                  );
                },
              ),
              onTap: () => _showCustomSectionDialog(context, section),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showCustomSectionDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addCustomSection),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showCustomSectionDialog(
    BuildContext context,
    CustomSectionModel? existing,
  ) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final contentController = TextEditingController(
      text: existing?.content ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.edit : loc.addCustomSection,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormDialogField(
              controller: titleController,
              label: loc.sectionTitle,
            ),
            FormDialogField(
              controller: contentController,
              label: loc.sectionContent,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newSection = CustomSectionModel(
                  title: titleController.text,
                  content: contentController.text,
                );
                final cubit = context.read<CVBuilderCubit>();
                final currentList = List<CustomSectionModel>.from(
                  cubit.state.currentCv.customSections,
                );

                if (isEditing) {
                  final index = currentList.indexOf(existing);
                  if (index != -1) currentList[index] = newSection;
                } else {
                  currentList.add(newSection);
                }
                cubit.updateField(customSections: currentList);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
