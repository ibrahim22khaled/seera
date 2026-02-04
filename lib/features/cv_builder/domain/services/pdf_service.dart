import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/cv_model.dart';

abstract class PdfService {
  Future<File> generatePdf(CVModel data);
}

class PdfServiceImpl implements PdfService {
  @override
  Future<File> generatePdf(CVModel data) async {
    final pdf = pw.Document();

    // Load Arabic Font using printing package
    final cairo = await PdfGoogleFonts.cairoRegular();
    final cairoBold = await PdfGoogleFonts.cairoBold();

    final theme = pw.ThemeData.withFont(base: cairo, bold: cairoBold);

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header - Name
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      data.fullName,
                      style: pw.TextStyle(
                        font: cairoBold,
                        fontSize: 24,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data.jobTitle,
                      style: pw.TextStyle(
                        font: cairo,
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        _buildHeaderItem(data.email, PdfColors.blue),
                        _buildHeaderItem(data.phone, PdfColors.black),
                        _buildHeaderItem(
                          '${data.city}, ${data.country}',
                          PdfColors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary
              if (data.summary.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Professional Summary', cairoBold),
                pw.Text(
                  data.summary,
                  style: pw.TextStyle(
                    font: cairo,
                    fontSize: 10,
                    lineSpacing: 1.5,
                  ),
                ),
                pw.SizedBox(height: 15),
              ],

              // Experience
              if (data.experience.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Experience', cairoBold),
                ...data.experience.map(
                  (exp) => _buildExperienceItem(exp, cairo, cairoBold),
                ),
                pw.SizedBox(height: 10),
              ],

              // Education
              if (data.education.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Education', cairoBold),
                ...data.education.map(
                  (edu) => _buildEducationItem(edu, cairo, cairoBold),
                ),
                pw.SizedBox(height: 10),
              ],

              // Skills
              if (data.skills.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Skills', cairoBold),
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: data.skills
                      .map(
                        (skill) => pw.Text(
                          '• $skill',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      )
                      .toList(),
                ),
                pw.SizedBox(height: 15),
              ],

              // Languages
              if (data.languages.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Languages', cairoBold),
                pw.Wrap(
                  spacing: 20,
                  children: data.languages
                      .map(
                        (lang) => pw.Text(
                          '${lang.name}: ${lang.level}',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      )
                      .toList(),
                ),
                pw.SizedBox(height: 15),
              ],

              // Additional Info
              if (data.additionalInfo.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Additional Information', cairoBold),
                pw.Text(
                  data.additionalInfo,
                  style: pw.TextStyle(font: cairo, fontSize: 10),
                ),
                pw.SizedBox(height: 15),
              ],

              // Work Samples
              if (data.attachments.isNotEmpty) ...[
                _buildLaTeXSectionTitle('Work Samples', cairoBold),
                ...data.attachments.map(
                  (link) => pw.Text(
                    '• $link',
                    style: pw.TextStyle(
                      font: cairo,
                      fontSize: 9,
                      color: PdfColors.blue,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${data.fullName}_Seera_CV.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildHeaderItem(String text, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 9, color: color)),
    );
  }

  pw.Widget _buildLaTeXSectionTitle(String title, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 2, bottom: 8),
          height: 1,
          color: PdfColors.blue900,
        ),
      ],
    );
  }

  pw.Widget _buildExperienceItem(
    ExperienceModel exp,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${exp.jobTitle} | ${exp.company}',
                style: pw.TextStyle(font: boldFont, fontSize: 11),
              ),
              pw.Text(
                exp.duration,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          if (exp.description.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2, bottom: 2),
              child: pw.Text(
                exp.description,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
          ...exp.responsibilities.map(
            (res) => pw.Padding(
              padding: const pw.EdgeInsets.only(right: 8),
              child: pw.Text('• $res', style: pw.TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(
    EducationModel edu,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            edu.certificate,
            style: pw.TextStyle(font: boldFont, fontSize: 10),
          ),
          pw.Text(
            edu.date,
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }
}
