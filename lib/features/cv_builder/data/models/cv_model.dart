class CVModel {
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String country;
  final String city;
  // final String targetCountry; // Removed

  final String summary;
  final List<String> skills;
  final List<ExperienceModel> experience;
  final List<EducationModel> education;
  final List<LanguageModel> languages;

  final String additionalInfo;

  // New fields
  final String linkedin;
  final String github;
  final List<CustomSectionModel> customSections;

  /// Projects with Role
  final List<ProjectModel> projects;

  CVModel({
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    // required this.targetCountry,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.education,
    required this.languages,
    required this.projects,
    required this.additionalInfo,
    this.linkedin = '',
    this.github = '',
    this.customSections = const [],
    this.id,
    this.updatedAt,
  });

  factory CVModel.initial() => CVModel(
    fullName: '',
    jobTitle: '',
    email: '',
    phone: '',
    country: '',
    city: '',
    summary: '',
    skills: [],
    experience: [],
    education: [],
    languages: [],
    projects: [],
    additionalInfo: '',
    linkedin: '',
    github: '',
    customSections: [],
  );

  factory CVModel.fromJson(Map<String, dynamic> json) {
    var projs = <ProjectModel>[];
    if (json['projects'] != null) {
      projs = (json['projects'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } else if (json['attachments'] != null) {
      // Backward compatibility
      projs = (json['attachments'] as List).map((e) {
        final title = e['title'] ?? '';
        final url = e['url'] ?? '';
        return ProjectModel(title: title, role: '', url: url, description: '');
      }).toList();
    }

    return CVModel(
      id: json['id'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      fullName: json['fullName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      // targetCountry: json['targetCountry'] ?? '',
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
      projects: projs,
      additionalInfo: json['additionalInfo'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      customSections: (json['customSections'] as List? ?? [])
          .map((e) => CustomSectionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'updatedAt': updatedAt?.toIso8601String(),
    'fullName': fullName,
    'jobTitle': jobTitle,
    'email': email,
    'phone': phone,
    'country': country,
    'city': city,
    // 'targetCountry': targetCountry,
    'summary': summary,
    'skills': skills,
    'experience': experience.map((e) => e.toJson()).toList(),
    'education': education.map((e) => e.toJson()).toList(),
    'languages': languages.map((e) => e.toJson()).toList(),
    'projects': projects.map((e) => e.toJson()).toList(),
    'additionalInfo': additionalInfo,
    'linkedin': linkedin,
    'github': github,
    'customSections': customSections.map((e) => e.toJson()).toList(),
  };

  CVModel copyWith({
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? country,
    String? city,
    // String? targetCountry,
    String? summary,
    List<String>? skills,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    List<LanguageModel>? languages,
    List<ProjectModel>? projects,
    String? additionalInfo,
    String? linkedin,
    String? github,
    List<CustomSectionModel>? customSections,
    String? id,
    DateTime? updatedAt,
  }) {
    return CVModel(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      // targetCountry: targetCountry ?? this.targetCountry,
      summary: summary ?? this.summary,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      languages: languages ?? this.languages,
      projects: projects ?? this.projects,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      customSections: customSections ?? this.customSections,
    );
  }

  final String? id;
  final DateTime? updatedAt;
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

  Map<String, dynamic> toJson() => {
    'company': company,
    'jobTitle': jobTitle,
    'duration': duration,
    'description': description,
    'location': location,
    'responsibilities': responsibilities,
    'portfolioItems': portfolioItems,
  };
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

  Map<String, dynamic> toJson() => {
    'degree': degree,
    'institution': institution,
    'dateRange': dateRange,
  };
}

class LanguageModel {
  final String name;
  final String level;

  LanguageModel({required this.name, required this.level});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(name: json['name'] ?? '', level: json['level'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name, 'level': level};
}

class ProjectModel {
  final String title;
  final String role;
  final String url;
  final String description;

  ProjectModel({
    required this.title,
    required this.role,
    required this.url,
    required this.description,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      role: json['role'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'role': role,
    'url': url,
    'description': description,
  };
}

class CustomSectionModel {
  final String title;
  final String content;

  CustomSectionModel({required this.title, required this.content});

  factory CustomSectionModel.fromJson(Map<String, dynamic> json) {
    return CustomSectionModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'content': content};
}
