import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/cv_builder_cubit.dart';
import 'form_section_header.dart';
import 'form_dialog_field.dart';

class LanguagesSection extends StatelessWidget {
  final List<LanguageModel> languages;

  const LanguagesSection({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.languagesSection),
        ...languages.map((lang) {
          return Card(
            color: AppTheme.surfaceBg,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                lang.name,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                lang.level,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<LanguageModel>.from(languages)
                    ..remove(lang);
                  context.read<CVBuilderCubit>().updateField(
                    languages: newList,
                  );
                },
              ),
              onTap: () => _showLanguageDialog(context, lang),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showLanguageDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addLanguage),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageModel? existing) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = existing != null;
    final langController = TextEditingController(text: existing?.name ?? '');
    final levelController = TextEditingController(text: existing?.level ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.edit : loc.addLanguage,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormDialogField(
              controller: langController,
              label: loc.languageField,
            ),
            FormDialogField(controller: levelController, label: loc.levelField),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              final newLang = LanguageModel(
                name: langController.text,
                level: levelController.text,
              );

              final cubit = context.read<CVBuilderCubit>();
              final currentList = List<LanguageModel>.from(
                cubit.state.currentCv.languages,
              );

              if (isEditing) {
                final index = currentList.indexOf(existing);
                if (index != -1) currentList[index] = newLang;
              } else {
                currentList.add(newLang);
              }
              cubit.updateField(languages: currentList);
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
