import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cv_model.dart';
import 'package:seera/features/chat/presentation/cubit/chat_cubit.dart';

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
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _targetCountryController; // Added
  late TextEditingController _jobTitleController;
  late TextEditingController _summaryController;
  late TextEditingController _additionalInfoController;

  late List<String> _skills;
  late List<LanguageModel> _languages;
  late List<EducationModel> _education;
  late List<ExperienceModel> _experience;
  late List<AttachmentModel> _attachments;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cvData.fullName);
    _phoneController = TextEditingController(text: widget.cvData.phone);
    _emailController = TextEditingController(text: widget.cvData.email);
    _cityController = TextEditingController(text: widget.cvData.city);
    _countryController = TextEditingController(text: widget.cvData.country);
    _targetCountryController = TextEditingController(
      text: widget.cvData.targetCountry,
    );
    _jobTitleController = TextEditingController(text: widget.cvData.jobTitle);
    _summaryController = TextEditingController(text: widget.cvData.summary);
    _additionalInfoController = TextEditingController(
      text: widget.cvData.additionalInfo,
    );

    _skills = List.from(widget.cvData.skills);
    _languages = List.from(widget.cvData.languages);
    _education = List.from(widget.cvData.education);
    _experience = List.from(widget.cvData.experience);
    _attachments = List.from(widget.cvData.attachments);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _targetCountryController.dispose();
    _jobTitleController.dispose();
    _summaryController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راجع بياناتك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              final updated = widget.cvData.copyWith(
                fullName: _nameController.text.trim(),
                phone: _phoneController.text.trim(),
                email: _emailController.text.trim(),
                city: _cityController.text.trim(),
                country: _countryController.text.trim(),
                targetCountry: _targetCountryController.text.trim(),
                jobTitle: _jobTitleController.text.trim(),
                summary: _summaryController.text.trim(),
                additionalInfo: _additionalInfoController.text.trim(),
                skills: _skills,
                languages: _languages,
                education: _education,
                experience: _experience,
                attachments: _attachments,
              );

              context.read<ChatCubit>().finalizePdf(updated);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('المعلومات الأساسية'),
            _buildTextField('الاسم بالكامل', _nameController),
            _buildTextField('البريد الإلكتروني', _emailController),
            _buildTextField('رقم التليفون', _phoneController),
            Row(
              children: [
                Expanded(child: _buildTextField('المدينة', _cityController)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField('الدولة', _countryController)),
              ],
            ),
            _buildTextField('الدولة المستهدفة', _targetCountryController),
            _buildTextField('المسمى الوظيفي', _jobTitleController),
            _buildTextField('نبذة مختصرة', _summaryController, maxLines: 4),

            _sectionTitle('الخبرات العملية'),
            _buildExperienceEditor(),

            _sectionTitle('التعليم'),
            _buildEducationEditor(),

            _sectionTitle('المهارات'),
            _buildSkillsEditor(),

            _sectionTitle('اللغات'),
            _buildLanguagesEditor(),

            _sectionTitle('المشاريع / Portfolio'),
            _buildAttachmentsEditor(),

            _sectionTitle('معلومات إضافية'),
            _buildTextField(
              'أي معلومات أخرى',
              _additionalInfoController,
              maxLines: 3,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildExperienceEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._experience.map((exp) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${exp.jobTitle} - ${exp.company}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () =>
                            setState(() => _experience.remove(exp)),
                      ),
                    ],
                  ),
                  Text(
                    exp.duration,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  if (exp.portfolioItems.isNotEmpty) ...[
                    const Text(
                      'نماذج الأعمال / روابط:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...exp.portfolioItems.map(
                      (item) => Text(
                        '• $item',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _showEditExperienceDialog(exp),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text(
                        'تعديل',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showAddExperienceDialog(),
          icon: const Icon(Icons.add),
          label: const Text('إضافة خبرة'),
        ),
      ],
    );
  }

  void _showAddExperienceDialog() {
    final roleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final durationController = TextEditingController();
    final descController = TextEditingController();
    final portfolioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة خبرة عملية'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'المسمى الوظيفي'),
              ),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'الشركة'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'المكان'),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'المدة (مثلاً: ٢٠٢٠ - ٢٠٢٢)',
                ),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'المهام (افصل بـ -)',
                ),
                maxLines: 3,
              ),
              TextField(
                controller: portfolioController,
                decoration: const InputDecoration(
                  labelText: 'روابط أعمال (افصل بـ space)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (roleController.text.isNotEmpty) {
                setState(() {
                  _experience.add(
                    ExperienceModel(
                      company: companyController.text,
                      jobTitle: roleController.text,
                      duration: durationController.text,
                      location: locationController.text,
                      description: descController.text,
                      responsibilities: descController.text
                          .split('-')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      portfolioItems: portfolioController.text
                          .split(RegExp(r'[,\n\s]+'))
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                    ),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditExperienceDialog(ExperienceModel exp) {
    final roleController = TextEditingController(text: exp.jobTitle);
    final companyController = TextEditingController(text: exp.company);
    final locationController = TextEditingController(text: exp.location);
    final durationController = TextEditingController(text: exp.duration);
    final descController = TextEditingController(
      text: exp.responsibilities.join(' - '),
    );
    final portfolioController = TextEditingController(
      text: exp.portfolioItems.join(' '),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل خبرة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'المسمى الوظيفي'),
              ),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'الشركة'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'المكان'),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'المدة'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'المهام'),
                maxLines: 3,
              ),
              TextField(
                controller: portfolioController,
                decoration: const InputDecoration(labelText: 'روابط أعمال'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _experience.indexOf(exp);
                _experience[index] = ExperienceModel(
                  company: companyController.text,
                  jobTitle: roleController.text,
                  duration: durationController.text,
                  location: locationController.text,
                  description: descController.text,
                  responsibilities: descController.text
                      .split('-')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  portfolioItems: portfolioController.text
                      .split(RegExp(r'[,\n\s]+'))
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // ================= EDUCATION =================

  Widget _buildEducationEditor() {
    return Column(
      children: [
        ..._education.map(
          (edu) => ListTile(
            title: Text(edu.degree),
            subtitle: Text('${edu.institution} | ${edu.dateRange}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _education.remove(edu)),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _showAddEducationDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة تعليم'),
        ),
      ],
    );
  }

  void _showAddEducationDialog() {
    final degree = TextEditingController();
    final institution = TextEditingController();
    final date = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة تعليم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: degree,
              decoration: const InputDecoration(labelText: 'الدرجة العلمية'),
            ),
            TextField(
              controller: institution,
              decoration: const InputDecoration(labelText: 'المؤسسة'),
            ),
            TextField(
              controller: date,
              decoration: const InputDecoration(labelText: 'الفترة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (degree.text.isNotEmpty) {
                setState(() {
                  _education.add(
                    EducationModel(
                      degree: degree.text,
                      institution: institution.text,
                      dateRange: date.text,
                    ),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ================= SKILLS =================

  Widget _buildSkillsEditor() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: _skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  onDeleted: () => setState(() => _skills.remove(skill)),
                ),
              )
              .toList(),
        ),
        TextButton.icon(
          onPressed: _showAddSkillDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة مهارة'),
        ),
      ],
    );
  }

  void _showAddSkillDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة مهارة'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _skills.add(controller.text));
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ================= LANGUAGES =================

  Widget _buildLanguagesEditor() {
    return Column(
      children: [
        ..._languages.map(
          (lang) => ListTile(
            title: Text(lang.name),
            subtitle: Text(lang.level),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _languages.remove(lang)),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _showAddLanguageDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة لغة'),
        ),
      ],
    );
  }

  void _showAddLanguageDialog() {
    final name = TextEditingController();
    final level = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة لغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'اللغة'),
            ),
            TextField(
              controller: level,
              decoration: const InputDecoration(labelText: 'المستوى'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (name.text.isNotEmpty) {
                setState(() {
                  _languages.add(
                    LanguageModel(name: name.text, level: level.text),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ================= ATTACHMENTS =================

  Widget _buildAttachmentsEditor() {
    return Column(
      children: [
        ..._attachments.map(
          (a) => ListTile(
            title: Text(a.title),
            subtitle: Text(a.url),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _attachments.remove(a)),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _showAddAttachmentDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة مشروع / رابط'),
        ),
      ],
    );
  }

  void _showAddAttachmentDialog() {
    final title = TextEditingController();
    final url = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة مشروع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: url,
              decoration: const InputDecoration(labelText: 'الرابط'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (title.text.isNotEmpty && url.text.isNotEmpty) {
                setState(() {
                  _attachments.add(
                    AttachmentModel(
                      title: title.text,
                      url: url.text,
                      type: AttachmentType.website,
                    ),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
