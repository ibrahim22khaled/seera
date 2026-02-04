import 'package:seera/features/cv_builder/data/models/cv_model.dart';

class AtsService {
  static String generatePlainTextCv(CVModel data) {
    final buffer = StringBuffer();

    // Full Name
    buffer.writeln(data.fullName.toUpperCase());
    buffer.writeln();

    // Professional Summary
    buffer.writeln('Professional Summary');
    buffer.writeln(data.summary);
    buffer.writeln();

    // Experience
    if (data.experience.isNotEmpty) {
      buffer.writeln('Experience');
      for (var exp in data.experience) {
        buffer.writeln('${exp.jobTitle} – ${exp.company}');
        buffer.writeln(exp.duration);
        for (var responsibility in exp.responsibilities) {
          buffer.writeln('- $responsibility');
        }
        buffer.writeln();
      }
    }

    // Skills
    if (data.skills.isNotEmpty) {
      buffer.writeln('Skills');
      for (var skill in data.skills) {
        buffer.writeln('- $skill');
      }
      buffer.writeln();
    }

    // Education (if any, not explicitly in model but good for ATS)
    // Languages
    if (data.languages.isNotEmpty) {
      buffer.writeln('Languages');
      for (var lang in data.languages) {
        buffer.writeln('- ${lang.name}: ${lang.level}');
      }
      buffer.writeln();
    }

    // Work Samples
    if (data.attachments.isNotEmpty) {
      buffer.writeln('Work Samples');
      for (var link in data.attachments) {
        buffer.writeln('- $link');
      }
      buffer.writeln();
    }

    // Contact Information
    buffer.writeln('Contact Information');
    buffer.writeln('Email: ${data.email}');
    buffer.writeln('Phone: ${data.phone}');
    buffer.writeln('Location: ${data.city}, ${data.country}');

    return buffer.toString();
  }
}
