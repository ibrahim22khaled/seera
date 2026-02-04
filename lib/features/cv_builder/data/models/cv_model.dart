class CVModel {
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final String city;
  final String jobTitle;
  final String targetCountry;
  final String summary;
  final List<String> skills;
  final List<ExperienceModel> experience;
  final List<EducationModel> education;
  final List<LanguageModel> languages;
  final String additionalInfo;
  final List<String> attachments;

  CVModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.jobTitle,
    required this.targetCountry,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.education,
    required this.languages,
    required this.additionalInfo,
    required this.attachments,
  });

  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
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
      additionalInfo: json['additionalInfo'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
    );
  }

  CVModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? country,
    String? city,
    String? jobTitle,
    String? targetCountry,
    String? summary,
    List<String>? skills,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    List<LanguageModel>? languages,
    String? additionalInfo,
    List<String>? attachments,
  }) {
    return CVModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      jobTitle: jobTitle ?? this.jobTitle,
      targetCountry: targetCountry ?? this.targetCountry,
      summary: summary ?? this.summary,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      languages: languages ?? this.languages,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      attachments: attachments ?? this.attachments,
    );
  }
}

class ExperienceModel {
  final String company;
  final String jobTitle; // Added
  final String duration;
  final String description;
  final List<String> responsibilities; // Added

  ExperienceModel({
    required this.company,
    required this.jobTitle,
    required this.duration,
    required this.description,
    required this.responsibilities,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'] ?? '',
      jobTitle: json['jobTitle'] ?? json['role'] ?? '', // Fallback to role
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      responsibilities: json['responsibilities'] != null
          ? List<String>.from(json['responsibilities'])
          : (json['description'] != null
                ? [json['description']]
                : []), // Fallback to description
    );
  }
}

class EducationModel {
  final String certificate;
  final String date;

  EducationModel({required this.certificate, required this.date});

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      certificate: json['certificate'] ?? json['degree'] ?? '',
      date: json['date'] ?? json['year'] ?? '',
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
