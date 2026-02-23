import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import '../cubit/cv_builder_cubit.dart';
import '../cubit/cv_builder_state.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/core/services/validator.dart';
import 'package:seera/features/cv_builder/presentation/pages/review_cv_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/form_section_header.dart';
import '../widgets/form_text_field.dart';
import '../widgets/experience_section.dart';
import '../widgets/education_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/languages_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/custom_sections_widget.dart';

class ManualFormScreen extends StatefulWidget {
  const ManualFormScreen({super.key});

  @override
  State<ManualFormScreen> createState() => _ManualFormScreenState();
}

class _ManualFormScreenState extends State<ManualFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resetCounter = 0;

  List<String> _sectionOrder = [
    'basic_info',
    'summary',
    'experience',
    'education',
    'skills',
    'languages',
    'projects',
    'custom_sections',
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.manualMode),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Reorder Sections',
            onPressed: _showReorderDialog,
          ),
        ],
      ),
      body: BlocBuilder<CVBuilderCubit, CVBuilderState>(
        builder: (context, state) {
          final cv = state.currentCv;
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              key: ValueKey(_resetCounter),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._sectionOrder.map(
                    (sectionId) => _buildSection(sectionId, cv, loc),
                  ),
                  const SizedBox(height: 40),
                  _buildPreviewButton(loc),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showClearDataDialog,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  Widget _buildSection(String sectionId, CVModel cv, AppLocalizations loc) {
    switch (sectionId) {
      case 'basic_info':
        return _buildBasicInfo(cv, loc);
      case 'summary':
        return _buildSummary(cv, loc);
      case 'experience':
        return ExperienceSection(experience: cv.experience);
      case 'education':
        return EducationSection(education: cv.education);
      case 'skills':
        return SkillsSection(skills: cv.skills);
      case 'languages':
        return LanguagesSection(languages: cv.languages);
      case 'projects':
        return ProjectsSection(projects: cv.projects);
      case 'custom_sections':
        return CustomSectionsWidget(sections: cv.customSections);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfo(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.basicInfo),
        FormTextField(
          label: loc.fullNameLabel,
          value: cv.fullName,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(fullName: v),
          validator: (v) => Validator.validateField('fullname', v ?? '', loc),
        ),
        FormTextField(
          label: loc.emailLabel,
          value: cv.email,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(email: v),
          validator: (v) => Validator.validateField('email', v ?? '', loc),
        ),
        FormTextField(
          label: loc.phoneLabel,
          value: cv.phone,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(phone: v),
          validator: (v) => Validator.validateField('phone', v ?? '', loc),
        ),
        Row(
          children: [
            Expanded(
              child: FormTextField(
                label: loc.cityLabel,
                value: cv.city,
                onChanged: (v) =>
                    context.read<CVBuilderCubit>().updateField(city: v),
                validator: (v) => Validator.validateField('city', v ?? '', loc),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FormTextField(
                label: loc.countryLabel,
                value: cv.country,
                onChanged: (v) =>
                    context.read<CVBuilderCubit>().updateField(country: v),
                validator: (v) =>
                    Validator.validateField('country', v ?? '', loc),
              ),
            ),
          ],
        ),
        FormTextField(
          label: loc.jobTitleLabel,
          value: cv.jobTitle,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(jobTitle: v),
          validator: (v) => Validator.validateField('jobtitle', v ?? '', loc),
        ),
        FormTextField(
          label: loc.linkedinLabel,
          value: cv.linkedin,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(linkedin: v),
          validator: (v) => Validator.validateField('linkedin', v ?? '', loc),
        ),
        FormTextField(
          label: loc.githubLabel,
          value: cv.github,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(github: v),
          validator: (v) => Validator.validateField('github', v ?? '', loc),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSummary(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: loc.summaryLabel),
        FormTextField(
          label: loc.summaryPlaceholder,
          value: cv.summary,
          onChanged: (v) =>
              context.read<CVBuilderCubit>().updateField(summary: v),
          maxLines: 4,
          validator: (v) => Validator.isNotEmpty(v ?? '') ? null : loc.required,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPreviewButton(AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePreview,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(loc.previewPdf),
      ),
    );
  }

  Future<void> _handlePreview() async {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<CVBuilderCubit>().saveCurrentCV();
        if (mounted) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            _showLoginSnackBar(loc);
            Navigator.pushNamed(context, '/login');
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewCvScreen(
                messages: const [],
                cvData: context.read<CVBuilderCubit>().state.currentCv,
              ),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseFillAllFields),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showLoginSnackBar(AppLocalizations loc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.pleaseLoginToPrint),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClearDataDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBg,
        title: Text(loc.clearData, style: const TextStyle(color: Colors.white)),
        content: Text(
          loc.clearDataConfirmation,
          style: const TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CVBuilderCubit>().resetCV();
              setState(() => _resetCounter++);
              Navigator.pop(context);
            },
            child: Text(
              loc.delete,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          loc.reorderSections,
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _sectionOrder.removeAt(oldIndex);
                _sectionOrder.insert(newIndex, item);
              });
            },
            children: [
              for (final section in _sectionOrder)
                ListTile(
                  key: ValueKey(section),
                  title: Text(
                    _getSectionTitle(section, loc),
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.drag_handle, color: Colors.grey),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }

  String _getSectionTitle(String sectionId, AppLocalizations loc) {
    switch (sectionId) {
      case 'basic_info':
        return loc.basicInfo;
      case 'summary':
        return loc.summaryLabel;
      case 'experience':
        return loc.experienceSection;
      case 'education':
        return loc.educationSection;
      case 'skills':
        return loc.skillsSection;
      case 'languages':
        return loc.languagesSection;
      case 'projects':
        return loc.projectsSection;
      case 'custom_sections':
        return loc.customSections;
      default:
        return '';
    }
  }
}
