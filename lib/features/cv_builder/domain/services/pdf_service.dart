import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/cv_model.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

abstract class PdfService {
  Future<File> generatePdf(CVModel data, AppLocalizations loc);
}

class PdfServiceImpl implements PdfService {
  // Color scheme for professional CV
  static final PdfColor primaryColor = PdfColors.black;
  static final PdfColor secondaryColor = PdfColors.grey900;
  static final PdfColor accentColor = PdfColors.blue900;
  static final PdfColor dividerColor = PdfColors.grey400;

  @override
  Future<File> generatePdf(CVModel data, AppLocalizations loc) async {
    final pdf = pw.Document();

    // Fonts supporting Arabic and English characters
    final regularFont = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            pw.Directionality(
              textDirection: pw.TextDirection.ltr,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  /// ================= HEADER =================
                  _buildHeader(data, regularFont, boldFont),
                  pw.SizedBox(height: 15),
                  pw.Divider(color: dividerColor, thickness: 1),
                  pw.SizedBox(height: 15),

                  /// ================= SUMMARY =================
                  if (data.summary.isNotEmpty) ...[
                    _buildSection(
                      title: loc.summaryLabel,
                      boldFont: boldFont,
                      content: pw.Text(
                        data.summary,
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 10,
                          lineSpacing: 1.3,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Divider(color: dividerColor, thickness: 1),
                    pw.SizedBox(height: 15),
                  ],

                  /// ================= EXPERIENCE =================
                  if (data.experience.isNotEmpty) ...[
                    _buildSection(
                      title: loc.experienceSection,
                      boldFont: boldFont,
                      content: pw.Column(
                        children: data.experience
                            .map(
                              (exp) => _buildExperienceItem(
                                exp,
                                regularFont,
                                boldFont,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Divider(color: dividerColor, thickness: 1),
                    pw.SizedBox(height: 15),
                  ],

                  /// ================= EDUCATION =================
                  if (data.education.isNotEmpty) ...[
                    _buildSection(
                      title: loc.educationSection,
                      boldFont: boldFont,
                      content: pw.Column(
                        children: data.education
                            .map(
                              (edu) => _buildEducationItem(
                                edu,
                                regularFont,
                                boldFont,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Divider(color: dividerColor, thickness: 1),
                    pw.SizedBox(height: 15),
                  ],

                  /// ================= PROJECTS =================
                  if (data.projects.isNotEmpty) ...[
                    _buildSection(
                      title: loc.projectsSection,
                      boldFont: boldFont,
                      content: pw.Column(
                        children: data.projects
                            .map(
                              (proj) => _buildProjectItem(
                                proj,
                                regularFont,
                                boldFont,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Divider(color: dividerColor, thickness: 1),
                    pw.SizedBox(height: 15),
                  ],

                  /// ================= SKILLS =================
                  if (data.skills.isNotEmpty) ...[
                    _buildSection(
                      title: loc.skillsSection,
                      boldFont: boldFont,
                      content: _buildSkillsGrid(data.skills, regularFont),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Divider(color: dividerColor, thickness: 1),
                    pw.SizedBox(height: 15),
                  ],

                  /// ================= LANGUAGES =================
                  if (data.languages.isNotEmpty) ...[
                    _buildSection(
                      title: loc.languagesSection,
                      boldFont: boldFont,
                      content: _buildLanguages(
                        data.languages,
                        regularFont,
                        boldFont,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final fileName =
        '${data.fullName.replaceAll(RegExp(r"[^\w\s]+"), "").replaceAll(" ", "_")}_CV.pdf';
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildHeader(CVModel data, pw.Font regularFont, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          data.fullName.toUpperCase(),
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 22,
            color: primaryColor,
          ),
        ),
        pw.Text(
          data.jobTitle,
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 13,
            color: accentColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 15,
          runSpacing: 5,
          children: [
            if (data.email.isNotEmpty)
              _buildContactItem(data.email, regularFont),
            if (data.phone.isNotEmpty)
              _buildContactItem(data.phone, regularFont),
            if (data.city.isNotEmpty)
              _buildContactItem('${data.city}, ${data.country}', regularFont),
            if (data.linkedin.isNotEmpty)
              _buildContactItem(data.linkedin, regularFont),
            if (data.github.isNotEmpty)
              _buildContactItem(data.github, regularFont),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildContactItem(String text, pw.Font font) {
    return pw.Text(
      text,
      style: pw.TextStyle(font: font, fontSize: 9, color: secondaryColor),
    );
  }

  pw.Widget _buildSection({
    required String title,
    required pw.Font boldFont,
    required pw.Widget content,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 11,
            color: accentColor,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 8),
        content,
      ],
    );
  }

  pw.Widget _buildExperienceItem(
    ExperienceModel exp,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  exp.company,
                  style: pw.TextStyle(font: boldFont, fontSize: 11),
                ),
              ),
              pw.Text(
                exp.duration,
                style: pw.TextStyle(font: regularFont, fontSize: 9),
              ),
            ],
          ),
          pw.Text(
            exp.jobTitle,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: 10,
              color: secondaryColor,
            ),
          ),
          if (exp.responsibilities.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            ...exp.responsibilities.map(
              (r) => _buildBulletPoint(r, regularFont),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(
    EducationModel edu,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  edu.degree,
                  style: pw.TextStyle(font: boldFont, fontSize: 11),
                ),
              ),
              pw.Text(
                edu.dateRange,
                style: pw.TextStyle(font: regularFont, fontSize: 9),
              ),
            ],
          ),
          pw.Text(
            edu.institution,
            style: pw.TextStyle(font: regularFont, fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItem(
    ProjectModel proj,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Project title with clickable link if URL exists
          pw.Row(
            children: [
              pw.Text(
                proj.title,
                style: pw.TextStyle(font: boldFont, fontSize: 11),
              ),
              if (proj.url.isNotEmpty) ...[
                pw.SizedBox(width: 8),
                pw.UrlLink(
                  destination: proj.url,
                  child: pw.Text(
                    '[Link]',
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 9,
                      color: accentColor,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Project role if exists
          if (proj.role.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              proj.role,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 9,
                color: secondaryColor,
              ),
            ),
          ],
          // Project description
          if (proj.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              proj.description,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 10,
                lineSpacing: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSkillsGrid(List<String> skills, pw.Font regularFont) {
    // ATS systems prefer clean comma-separated lines or simple bullets
    return pw.Text(
      skills.join('  |  '),
      style: pw.TextStyle(font: regularFont, fontSize: 10, color: primaryColor),
    );
  }

  pw.Widget _buildLanguages(
    List<LanguageModel> languages,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Wrap(
      spacing: 20,
      children: languages
          .map(
            (lang) => pw.Text(
              "${lang.name}: ${lang.level}",
              style: pw.TextStyle(font: regularFont, fontSize: 10),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _buildBulletPoint(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 5, bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: pw.TextStyle(font: font, fontSize: 10)),
          pw.Expanded(
            child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
