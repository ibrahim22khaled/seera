class CVModel {
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String country;
  final String city;
  final String targetCountry;

  final String summary;
  final List<String> skills;
  final List<ExperienceModel> experience;
  final List<EducationModel> education;
  final List<LanguageModel> languages;

  /// Portfolio / Work Samples (images converted to links)
  final List<AttachmentModel> attachments;

  final String additionalInfo;

  CVModel({
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.targetCountry,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.education,
    required this.languages,
    required this.attachments,
    required this.additionalInfo,
  });

  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      fullName: json['fullName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      targetCountry: json['targetCountry'] ?? '',
      summary: json['summary'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: (json['experience'] as List? ?? [])
          .map((e) => ExperienceModel.fromJson(e))
          .toList(),
      education: (json['education'] as List? ?? [])
          .map((e) => EducationModel.fromJson(e))
          .toList(),
      languages: (json['languages'] as List? ?? [])
          .map((e) => LanguageModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List? ?? [])
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      additionalInfo: json['additionalInfo'] ?? '',
    );
  }

  CVModel copyWith({
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? country,
    String? city,
    String? targetCountry,
    String? summary,
    List<String>? skills,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    List<LanguageModel>? languages,
    List<AttachmentModel>? attachments,
    String? additionalInfo,
  }) {
    return CVModel(
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      targetCountry: targetCountry ?? this.targetCountry,
      summary: summary ?? this.summary,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      languages: languages ?? this.languages,
      attachments: attachments ?? this.attachments,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}

class ExperienceModel {
  final String jobTitle;
  final String company;
  final String duration;
  final String description;
  final String location; // Added
  final List<String> responsibilities;
  final List<String> portfolioItems; // Added

  ExperienceModel({
    required this.company,
    required this.jobTitle,
    required this.duration,
    required this.description,
    required this.location,
    required this.responsibilities,
    required this.portfolioItems,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'] ?? '',
      jobTitle: json['jobTitle'] ?? json['role'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      responsibilities: json['responsibilities'] != null
          ? List<String>.from(json['responsibilities'])
          : (json['description'] != null ? [json['description']] : []),
      portfolioItems: List<String>.from(json['portfolioItems'] ?? []),
    );
  }
}

class EducationModel {
  final String degree;
  final String institution;
  final String dateRange;

  EducationModel({
    required this.degree,
    required this.institution,
    required this.dateRange,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      dateRange: json['dateRange'] ?? '',
    );
  }
}

class LanguageModel {
  final String name;
  final String level;

  LanguageModel({required this.name, required this.level});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(name: json['name'] ?? '', level: json['level'] ?? '');
  }
}

class AttachmentModel {
  final String title;
  final String url;
  final AttachmentType type;

  AttachmentModel({required this.title, required this.url, required this.type});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      type: AttachmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AttachmentType.website,
      ),
    );
  }
}

enum AttachmentType { image, github, behance, website, pdf }
