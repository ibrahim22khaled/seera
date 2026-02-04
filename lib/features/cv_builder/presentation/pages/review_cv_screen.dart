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
  late TextEditingController _jobTitleController;
  late TextEditingController _summaryController;
  late TextEditingController _additionalInfoController;
  late List<String> _skills;
  late List<LanguageModel> _languages;
  late List<EducationModel> _education;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cvData.fullName);
    _phoneController = TextEditingController(text: widget.cvData.phone);
    _emailController = TextEditingController(text: widget.cvData.email);
    _cityController = TextEditingController(text: widget.cvData.city);
    _countryController = TextEditingController(text: widget.cvData.country);
    _jobTitleController = TextEditingController(text: widget.cvData.jobTitle);
    _summaryController = TextEditingController(text: widget.cvData.summary);
    _additionalInfoController = TextEditingController(
      text: widget.cvData.additionalInfo,
    );
    _skills = List.from(widget.cvData.skills);
    _languages = List.from(widget.cvData.languages);
    _education = List.from(widget.cvData.education);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _jobTitleController.dispose();
    _summaryController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راجع بياناتك يا بطل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              final validatedData = widget.cvData.copyWith(
                fullName: _nameController.text,
                phone: _phoneController.text,
                email: _emailController.text,
                city: _cityController.text,
                country: _countryController.text,
                jobTitle: _jobTitleController.text,
                summary: _summaryController.text,
                education: _education,
                additionalInfo: _additionalInfoController.text,
                skills: _skills,
                languages: _languages,
              );
              context.read<ChatCubit>().finalizePdf(validatedData);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ده اللي جمعته من كلامنا. لو فيه حاجة مش مضبوطة، صلحها بنفسك:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('المعلومات الأساسية'),
            _buildTextField('الاسم بالكامل', _nameController),
            _buildTextField(
              'البريد الإلكتروني',
              _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              'رقم التليفون',
              _phoneController,
              keyboardType: TextInputType.phone,
            ),
            Row(
              children: [
                Expanded(child: _buildTextField('المدينة', _cityController)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField('الدولة', _countryController)),
              ],
            ),
            _buildTextField('المسمى الوظيفي', _jobTitleController),
            _buildTextField('ملخص قصير عنك', _summaryController, maxLines: 4),

            _buildSectionTitle('التعليم'),
            _buildEducationEditor(),

            _buildSectionTitle('المهارات'),
            _buildSkillsEditor(),

            _buildSectionTitle('اللغات'),
            _buildLanguagesEditor(),

            _buildSectionTitle('معلومات إضافية'),
            _buildTextField(
              'أي معلومات تانية حابب تضيفها',
              _additionalInfoController,
              maxLines: 3,
            ),

            const SizedBox(height: 100), // Spacing for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Divider(color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildEducationEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._education.map((edu) {
          return ListTile(
            title: Text(edu.certificate),
            subtitle: Text(edu.date),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _education.remove(edu)),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showAddEducationDialog(),
          icon: const Icon(Icons.add),
          label: const Text('إضافة تعليم'),
        ),
      ],
    );
  }

  void _showAddEducationDialog() {
    final certController = TextEditingController();
    final dateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة تعليم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: certController,
              decoration: const InputDecoration(labelText: 'الشهادة / التخصص'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'تاريخ التخرج'),
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
              if (certController.text.isNotEmpty) {
                setState(
                  () => _education.add(
                    EducationModel(
                      certificate: certController.text,
                      date: dateController.text,
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: _skills.map((skill) {
            return Chip(
              label: Text(skill),
              onDeleted: () {
                setState(() => _skills.remove(skill));
              },
            );
          }).toList(),
        ),
        TextButton.icon(
          onPressed: () => _showAddSkillDialog(),
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
      builder: (context) => AlertDialog(
        title: const Text('إضافة مهارة'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'مثلاً: Python, Design...',
          ),
        ),
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

  Widget _buildLanguagesEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._languages.map((lang) {
          return ListTile(
            title: Text(lang.name),
            subtitle: Text(lang.level),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _languages.remove(lang)),
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _showAddLanguageDialog(),
          icon: const Icon(Icons.add),
          label: const Text('إضافة لغة'),
        ),
      ],
    );
  }

  void _showAddLanguageDialog() {
    final langController = TextEditingController();
    final levelController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة لغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: langController,
              decoration: const InputDecoration(labelText: 'اللغة'),
            ),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(
                labelText: 'المستوى (مثلاً: Native)',
              ),
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
              if (langController.text.isNotEmpty) {
                setState(
                  () => _languages.add(
                    LanguageModel(
                      name: langController.text,
                      level: levelController.text,
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
