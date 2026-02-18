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

class ManualFormScreen extends StatefulWidget {
  const ManualFormScreen({super.key});

  @override
  State<ManualFormScreen> createState() => _ManualFormScreenState();
}

class _ManualFormScreenState extends State<ManualFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resetCounter = 0;

  // Order of sections
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
                  // Render sections based on order
                  ..._sectionOrder.map((sectionId) {
                    switch (sectionId) {
                      case 'basic_info':
                        return _buildBasicInfo(cv, loc);
                      case 'summary':
                        return _buildSummary(cv, loc);
                      case 'experience':
                        return _buildExperienceSection(cv, loc);
                      case 'education':
                        return _buildEducationSection(cv, loc);
                      case 'skills':
                        return _buildSkillsSection(cv, loc);
                      case 'languages':
                        return _buildLanguagesSection(cv, loc);
                      case 'projects':
                        return _buildProjectsSection(cv, loc);
                      case 'custom_sections':
                        return _buildCustomSections(cv, loc);
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await context
                                      .read<CVBuilderCubit>()
                                      .saveCurrentCV();
                                  if (mounted) {
                                    // Check Authentication
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              loc.pleaseLoginToPrint,
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                        Navigator.pushNamed(context, '/login');
                                      }
                                      return;
                                    }

                                    // Navigate to Review CV Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewCvScreen(
                                          messages: const [],
                                          cvData: context
                                              .read<CVBuilderCubit>()
                                              .state
                                              .currentCv,
                                        ),
                                      ),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loc.pleaseFillAllFields),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
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
                  ),
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
        child: const Icon(Icons.add, color: Colors.white),
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
              setState(() {
                _resetCounter++;
              });
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

  // --- SECTIONS ---

  Widget _buildBasicInfo(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.basicInfo),
        _buildTextField(
          loc.fullNameLabel,
          cv.fullName,
          (v) => context.read<CVBuilderCubit>().updateField(fullName: v),
          validator: (v) => Validator.validateField('fullname', v ?? '', loc),
        ),
        _buildTextField(
          loc.emailLabel,
          cv.email,
          (v) => context.read<CVBuilderCubit>().updateField(email: v),
          validator: (v) => Validator.validateField('email', v ?? '', loc),
        ),
        _buildTextField(
          loc.phoneLabel,
          cv.phone,
          (v) => context.read<CVBuilderCubit>().updateField(phone: v),
          validator: (v) => Validator.validateField('phone', v ?? '', loc),
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                loc.cityLabel,
                cv.city,
                (v) => context.read<CVBuilderCubit>().updateField(city: v),
                validator: (v) => Validator.validateField('city', v ?? '', loc),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                loc.countryLabel,
                cv.country,
                (v) => context.read<CVBuilderCubit>().updateField(country: v),
                validator: (v) =>
                    Validator.validateField('country', v ?? '', loc),
              ),
            ),
          ],
        ),
        _buildTextField(
          loc.jobTitleLabel,
          cv.jobTitle,
          (v) => context.read<CVBuilderCubit>().updateField(jobTitle: v),
          validator: (v) => Validator.validateField('jobtitle', v ?? '', loc),
        ),
        _buildTextField(
          loc.linkedinLabel,
          cv.linkedin,
          (v) => context.read<CVBuilderCubit>().updateField(linkedin: v),
          validator: (v) => Validator.validateField('linkedin', v ?? '', loc),
        ),
        _buildTextField(
          loc.githubLabel,
          cv.github,
          (v) => context.read<CVBuilderCubit>().updateField(github: v),
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
        _buildSectionHeader(loc.summaryLabel),
        _buildTextField(
          loc.summaryPlaceholder,
          cv.summary,
          (v) => context.read<CVBuilderCubit>().updateField(summary: v),
          maxLines: 4,
          validator: (v) => Validator.isNotEmpty(v ?? '') ? null : loc.required,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildExperienceSection(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.experienceSection),
        _buildExperienceList(context, cv.experience, loc),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEducationSection(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.educationSection),
        _buildEducationList(context, cv.education, loc),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSkillsSection(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.skillsSection),
        _buildSkillsList(context, cv.skills, loc),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLanguagesSection(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.languagesSection),
        _buildLanguagesList(context, cv.languages, loc),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProjectsSection(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.projectsSection),
        _buildProjectsList(context, cv.projects, loc),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCustomSections(CVModel cv, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.customSections),
        ...cv.customSections.map((section) {
          return Card(
            color: AppTheme.surfaceBg,
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
                  final newList = List<CustomSectionModel>.from(
                    cv.customSections,
                  )..remove(section);
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

  // --- WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value,
    Function(String) onChanged, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // --- Experience ---
  Widget _buildExperienceList(
    BuildContext context,
    List<ExperienceModel> experience,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...experience.map((exp) {
          return Card(
            color: AppTheme.surfaceBg,
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
                icon: const Icon(Icons.delete, color: Colors.redAccent),
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
              _buildDialogField(jobTitleController, loc.jobTitleField),
              _buildDialogField(companyController, loc.companyField),
              _buildDialogField(locationController, loc.locationField),
              _buildDialogField(durationController, loc.durationField),
              _buildDialogField(
                descController,
                loc.responsibilitiesField,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  // --- Education ---
  Widget _buildEducationList(
    BuildContext context,
    List<EducationModel> education,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...education.map((edu) {
          return Card(
            color: AppTheme.surfaceBg,
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
            _buildDialogField(degreeController, loc.degreeField),
            _buildDialogField(institutionController, loc.institutionField),
            _buildDialogField(dateController, loc.periodField),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  // --- Skills ---
  Widget _buildSkillsList(
    BuildContext context,
    List<String> skills,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
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
        content: _buildDialogField(controller, loc.skillsSection),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  // --- Languages ---
  Widget _buildLanguagesList(
    BuildContext context,
    List<LanguageModel> languages,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...languages.map((lang) {
          return Card(
            color: AppTheme.surfaceBg,
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
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showLanguageDialog(context),
          icon: const Icon(Icons.add),
          label: Text(loc.addLanguage),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final levelController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          loc.addLanguage,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nameController, loc.languageField),
            _buildDialogField(levelController, loc.levelField),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newLang = LanguageModel(
                  name: nameController.text,
                  level: levelController.text,
                );
                final cubit = context.read<CVBuilderCubit>();
                final currentList = List<LanguageModel>.from(
                  cubit.state.currentCv.languages,
                );
                currentList.add(newLang);
                cubit.updateField(languages: currentList);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  // --- Projects/Attachments ---
  // --- Projects ---
  Widget _buildProjectsList(
    BuildContext context,
    List<ProjectModel> projects,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...projects.map((proj) {
          return Card(
            color: AppTheme.surfaceBg,
            child: ListTile(
              title: Text(
                proj.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                // '${proj.role} • ${proj.url}\n${proj.description}',
                proj.role.isNotEmpty ? '${proj.role} - ${proj.url}' : proj.url,
                style: const TextStyle(color: AppTheme.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
      ],
    );
  }

  void _showProjectDialog(BuildContext context, ProjectModel? existing) {
    final isEditing = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final roleController = TextEditingController(text: existing?.role ?? '');
    final urlController = TextEditingController(text: existing?.url ?? '');
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: Text(
          isEditing ? loc.editProject : loc.addProject,
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(titleController, loc.titleField),
              _buildDialogField(roleController, loc.projectRole),
              _buildDialogField(urlController, loc.linkField),
              _buildDialogField(
                descController,
                loc.projectDescription,
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
              if (titleController.text.isNotEmpty) {
                final newProj = ProjectModel(
                  title: titleController.text,
                  role: roleController.text,
                  url: urlController.text,
                  description: descController.text,
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
              }
              Navigator.pop(dialogContext);
            },
            child: Text(isEditing ? loc.save : loc.add),
          ),
        ],
      ),
    );
  }

  // --- Custom Sections ---
  void _showCustomSectionDialog(
    BuildContext context,
    CustomSectionModel? existing,
  ) {
    final isEditing = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final contentController = TextEditingController(
      text: existing?.content ?? '',
    );
    final loc = AppLocalizations.of(context)!;

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
            _buildDialogField(titleController, loc.sectionTitle),
            _buildDialogField(
              contentController,
              loc.sectionContent,
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

  Widget _buildDialogField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
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
        ),
      ),
    );
  }
}
