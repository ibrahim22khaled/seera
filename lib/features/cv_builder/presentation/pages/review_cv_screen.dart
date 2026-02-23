import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cv_model.dart';

import 'package:seera/features/cv_builder/presentation/cubit/cv_builder_cubit.dart';
import 'package:seera/features/cv_builder/presentation/cubit/cv_builder_state.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:seera/features/cv_builder/domain/services/pdf_service.dart';
import 'package:printing/printing.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewCvScreen extends StatefulWidget {
  final List<String> messages;
  final CVModel cvData;

  const ReviewCvScreen({
    super.key,
    required this.messages,
    required this.cvData,
  });

  @override
  State<ReviewCvScreen> createState() => _ReviewCvScreenState();
}

class _ReviewCvScreenState extends State<ReviewCvScreen> {
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cvData.fullName);
    _jobTitleController = TextEditingController(text: widget.cvData.jobTitle);
    _emailController = TextEditingController(text: widget.cvData.email);
    _phoneController = TextEditingController(text: widget.cvData.phone);
    _cityController = TextEditingController(text: widget.cvData.city);
    _countryController = TextEditingController(text: widget.cvData.country);
    _linkedinController = TextEditingController(text: widget.cvData.linkedin);
    _githubController = TextEditingController(text: widget.cvData.github);
    _summaryController = TextEditingController(text: widget.cvData.summary);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final cubit = context.read<CVBuilderCubit>();
    final updatedCv = cubit.state.currentCv.copyWith(
      fullName: _nameController.text,
      jobTitle: _jobTitleController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      city: _cityController.text,
      country: _countryController.text,
      linkedin: _linkedinController.text,
      github: _githubController.text,
      summary: _summaryController.text,
    );

    cubit.updateCV(updatedCv);
  }

  Future<void> _previewPdf() async {
    if (_isLoading) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseLoginToPrint),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _saveChanges();
    try {
      final pdfService = PdfServiceImpl();
      final file = await pdfService.generatePdf(
        context.read<CVBuilderCubit>().state.currentCv,
        AppLocalizations.of(context)!,
      );
      await Printing.layoutPdf(
        onLayout: (format) => file.readAsBytes(),
        name: 'My_CV.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<CVBuilderCubit, CVBuilderState>(
      builder: (context, state) {
        final currentCv = state.currentCv;

        return Scaffold(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(loc.reviewData),
            backgroundColor: AppTheme.darkTheme.appBarTheme.backgroundColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSectionCard(loc.basicInfo, [
                  _buildTextField(loc.fullNameLabel, _nameController),
                  _buildTextField(loc.jobTitleLabel, _jobTitleController),
                  _buildTextField(loc.emailLabel, _emailController),
                  _buildTextField(loc.phoneLabel, _phoneController),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(loc.cityLabel, _cityController),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          loc.countryLabel,
                          _countryController,
                        ),
                      ),
                    ],
                  ),
                  _buildTextField(loc.linkedinLabel, _linkedinController),
                  _buildTextField(loc.githubLabel, _githubController),
                ]),
                const SizedBox(height: 16),
                _buildSectionCard(loc.summaryLabel, [
                  _buildTextField(
                    loc.summaryLabel,
                    _summaryController,
                    maxLines: 5,
                  ),
                ]),
                const SizedBox(height: 16),

                // Custom Sections
                _buildCustomSections(currentCv, loc),
                const SizedBox(height: 16),

                // Experience
                _buildExperienceSection(currentCv, loc),
                const SizedBox(height: 16),

                // Education
                _buildEducationSection(currentCv, loc),
                const SizedBox(height: 16),

                // Skills
                _buildSkillsSection(currentCv, loc),
                const SizedBox(height: 16),

                // Languages
                _buildLanguagesSection(currentCv, loc),
                const SizedBox(height: 16),

                // Projects
                _buildProjectsSection(currentCv, loc),
                const SizedBox(height: 16),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _previewPdf,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            loc.previewPdf,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          filled: true,
          fillColor: AppTheme.darkBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // --- Experience ---
  Widget _buildExperienceSection(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.experienceSection, [
      _buildExperienceList(context, cv.experience, loc),
    ]);
  }

  Widget _buildExperienceList(
    BuildContext context,
    List<ExperienceModel> experience,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...experience.map((exp) {
          return Card(
            color: AppTheme.darkBg,
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
              _buildTextField(loc.jobTitleField, jobTitleController),
              _buildTextField(loc.companyField, companyController),
              _buildTextField(loc.locationField, locationController),
              _buildTextField(loc.durationField, durationController),
              _buildTextField(
                loc.responsibilitiesField,
                descController,
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

  // --- Education ---
  Widget _buildEducationSection(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.educationSection, [
      _buildEducationList(context, cv.education, loc),
    ]);
  }

  Widget _buildEducationList(
    BuildContext context,
    List<EducationModel> education,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...education.map((edu) {
          return Card(
            color: AppTheme.darkBg,
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
            _buildTextField(loc.degreeField, degreeController),
            _buildTextField(loc.institutionField, institutionController),
            _buildTextField(loc.periodField, dateController),
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

  // --- Skills ---
  Widget _buildSkillsSection(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.skillsSection, [
      _buildSkillsList(context, cv.skills, loc),
    ]);
  }

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
        content: _buildTextField(loc.skillsSection, controller),
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

  // --- Languages ---
  Widget _buildLanguagesSection(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.languagesSection, [
      _buildLanguagesList(context, cv.languages, loc),
    ]);
  }

  Widget _buildLanguagesList(
    BuildContext context,
    List<LanguageModel> languages,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...languages.map((lang) {
          return Card(
            color: AppTheme.darkBg,
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
            _buildTextField(loc.languageField, nameController),
            _buildTextField(loc.levelField, levelController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
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
            child: Text(loc.add),
          ),
        ],
      ),
    );
  }

  // --- Projects ---
  Widget _buildProjectsSection(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.projectsSection, [
      _buildProjectsList(context, cv.projects, loc),
    ]);
  }

  Widget _buildProjectsList(
    BuildContext context,
    List<ProjectModel> projects,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...projects.map((proj) {
          return Card(
            color: AppTheme.darkBg,
            child: ListTile(
              title: Text(
                proj.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                proj.role.isNotEmpty
                    ? '${proj.role} - ${proj.urls.join(", ")}'
                    : proj.urls.join(", "),
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
    final urlController = TextEditingController(
      text: existing?.urls.join(', ') ?? '',
    );
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
              _buildTextField(loc.titleField, titleController),
              _buildTextField(loc.projectRole, roleController),
              _buildTextField(loc.linkField, urlController),
              _buildTextField(
                loc.projectDescription,
                descController,
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
                  urls: urlController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
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
  Widget _buildCustomSections(CVModel cv, AppLocalizations loc) {
    return _buildSectionCard(loc.customSections, [
      _buildCustomSectionsList(context, cv.customSections, loc),
    ]);
  }

  Widget _buildCustomSectionsList(
    BuildContext context,
    List<CustomSectionModel> sections,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        ...sections.map((sec) {
          return Card(
            color: AppTheme.darkBg,
            child: ListTile(
              title: Text(
                sec.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                sec.content,
                style: const TextStyle(color: AppTheme.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  final newList = List<CustomSectionModel>.from(sections)
                    ..remove(sec);
                  context.read<CVBuilderCubit>().updateField(
                    customSections: newList,
                  );
                },
              ),
              onTap: () => _showCustomSectionDialog(context, sec),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showCustomSectionDialog(context, null),
          icon: const Icon(Icons.add),
          label: Text(loc.addCustomSection),
        ),
      ],
    );
  }

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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(loc.sectionTitle, titleController),
              _buildTextField(
                loc.sectionContent,
                contentController,
                maxLines: 5,
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
                final newSec = CustomSectionModel(
                  title: titleController.text,
                  content: contentController.text,
                );
                final cubit = context.read<CVBuilderCubit>();
                final currentList = List<CustomSectionModel>.from(
                  cubit.state.currentCv.customSections,
                );

                if (isEditing) {
                  final index = currentList.indexOf(existing);
                  if (index != -1) currentList[index] = newSec;
                } else {
                  currentList.add(newSec);
                }

                cubit.updateField(customSections: currentList);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(isEditing ? loc.save : loc.add),
          ),
        ],
      ),
    );
  }
}
