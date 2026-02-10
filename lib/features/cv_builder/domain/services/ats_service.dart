import 'package:seera/features/cv_builder/data/models/cv_model.dart';

class AtsService {
  static String generatePlainTextCv(CVModel data) {
    final buffer = StringBuffer();

    /// HEADER
    buffer.writeln(data.fullName);
    buffer.writeln(data.jobTitle);
    buffer.writeln('${data.city}, ${data.country}');
    buffer.writeln('Email: ${data.email} | Phone: ${data.phone}');
    buffer.writeln();

    /// SUMMARY
    if (data.summary.isNotEmpty) {
      buffer.writeln('Summary');
      buffer.writeln(data.summary.trim());
      buffer.writeln();
    }

    /// SKILLS
    if (data.skills.isNotEmpty) {
      buffer.writeln('Skills');
      buffer.writeln(data.skills.join(', '));
      buffer.writeln();
    }

    /// EXPERIENCE
    if (data.experience.isNotEmpty) {
      buffer.writeln('Experience');
      for (final exp in data.experience) {
        buffer.writeln('${exp.jobTitle} | ${exp.company} | ${exp.location}');
        buffer.writeln(exp.duration);

        for (final bullet in exp.responsibilities) {
          buffer.writeln('- ${_normalizeBullet(bullet)}');
        }

        if (exp.portfolioItems.isNotEmpty) {
          buffer.writeln('  Portfolio:');
          for (final item in exp.portfolioItems) {
            buffer.writeln('  • $item');
          }
        }
        buffer.writeln();
      }
    }

    /// PROJECTS / PORTFOLIO (IMAGES → LINKS)
    if (data.attachments.isNotEmpty) {
      buffer.writeln('Projects');
      for (final item in data.attachments) {
        buffer.writeln('- ${item.title}: ${item.url}');
      }
      buffer.writeln();
    }

    /// EDUCATION
    if (data.education.isNotEmpty) {
      buffer.writeln('Education');
      for (final edu in data.education) {
        buffer.writeln('${edu.degree} | ${edu.institution} | ${edu.dateRange}');
      }
      buffer.writeln();
    }

    /// LANGUAGES
    if (data.languages.isNotEmpty) {
      buffer.writeln('Languages');
      for (final lang in data.languages) {
        buffer.writeln('${lang.name} – ${lang.level}');
      }
      buffer.writeln();
    }

    /// ADDITIONAL INFO
    if (data.additionalInfo.isNotEmpty) {
      buffer.writeln('Additional Information');
      buffer.writeln(data.additionalInfo);
    }

    return buffer.toString().trim();
  }

  static String _normalizeBullet(String text) {
    final t = text.trim();
    if (t.isEmpty) return t;
    return t[0].toUpperCase() + t.substring(1);
  }
}
