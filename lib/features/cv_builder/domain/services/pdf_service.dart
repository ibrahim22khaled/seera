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

    final regularFont = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return [
            /// ================= HEADER =================
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  data.fullName.toUpperCase(),
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 24,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  data.jobTitle,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      '${data.city}, ${data.country}',
                      style: pw.TextStyle(font: regularFont, fontSize: 10),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6),
                      child: pw.Text('|', style: pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Text(
                      data.email,
                      style: pw.TextStyle(font: regularFont, fontSize: 10),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6),
                      child: pw.Text('|', style: pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Text(
                      data.phone,
                      style: pw.TextStyle(font: regularFont, fontSize: 10),
                    ),
                  ],
                ),
                if (data.targetCountry.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'السوق المستهدف: ${data.targetCountry}',
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 10,
                      color: PdfColors.blueGrey700,
                    ),
                  ),
                ],
              ],
            ),

            pw.SizedBox(height: 20),

            /// ================= SUMMARY =================
            if (data.summary.isNotEmpty) ...[
              _sectionTitle('الملخص المهني', boldFont),
              pw.Paragraph(
                text: data.summary,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(font: regularFont, fontSize: 10),
              ),
              pw.SizedBox(height: 15),
            ],

            /// ================= EXPERIENCE =================
            if (data.experience.isNotEmpty) ...[
              _sectionTitle('الخبرات العملية', boldFont),
              ...data.experience.map(
                (exp) => _experienceItem(exp, regularFont, boldFont),
              ),
              pw.SizedBox(height: 10),
            ],

            /// ================= SKILLS =================
            if (data.skills.isNotEmpty) ...[
              _sectionTitle('المهارات', boldFont),
              pw.Bullet(
                text: data.skills.join(' • '),
                style: pw.TextStyle(font: regularFont, fontSize: 10),
              ),
              pw.SizedBox(height: 15),
            ],

            /// ================= PROJECTS =================
            if (data.attachments.isNotEmpty) ...[
              _sectionTitle('المشاريع ونماذج الأعمال', boldFont),
              ...data.attachments.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        item.title,
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                      pw.UrlLink(
                        destination: item.url,
                        child: pw.Text(
                          item.url,
                          textDirection: pw.TextDirection.ltr,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 9,
                            color: PdfColors.blue700,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
            ],

            /// ================= EDUCATION =================
            if (data.education.isNotEmpty) ...[
              _sectionTitle('التعليم', boldFont),
              ...data.education.map(
                (edu) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            edu.degree,
                            style: pw.TextStyle(font: boldFont, fontSize: 10),
                          ),
                          pw.Text(
                            edu.institution,
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                        ],
                      ),
                      pw.Text(
                        edu.dateRange,
                        style: pw.TextStyle(font: regularFont, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
            ],

            /// ================= LANGUAGES =================
            if (data.languages.isNotEmpty) ...[
              _sectionTitle('اللغات', boldFont),
              pw.Text(
                data.languages.map((l) => '${l.name} (${l.level})').join(' | '),
                style: pw.TextStyle(font: regularFont, fontSize: 10),
              ),
              pw.SizedBox(height: 15),
            ],

            /// ================= ADDITIONAL =================
            if (data.additionalInfo.isNotEmpty) ...[
              _sectionTitle('معلومات إضافية', boldFont),
              pw.Text(
                data.additionalInfo,
                style: pw.TextStyle(font: regularFont, fontSize: 10),
              ),
            ],
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

  /// ================= HELPERS =================

  pw.Widget _sectionTitle(String title, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 12,
            letterSpacing: 1.1,
            color: PdfColors.blueGrey900,
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 2, bottom: 8),
          height: 1,
          color: PdfColors.grey400,
        ),
      ],
    );
  }

  pw.Widget _experienceItem(
    ExperienceModel exp,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      exp.jobTitle,
                      style: pw.TextStyle(font: boldFont, fontSize: 11),
                    ),
                    pw.Text(
                      '${exp.company} | ${exp.location}',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Text(
                exp.duration,
                style: pw.TextStyle(font: font, fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          ...exp.responsibilities.map((r) => _buildBulletPoint(r, font)),

          // Add Portfolio Items
          if (exp.portfolioItems.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Text(
                  'نماذج الأعمال: ',
                  style: pw.TextStyle(font: boldFont, fontSize: 9),
                ),
                pw.Expanded(
                  child: pw.Text(
                    exp.portfolioItems.join(', '),
                    textDirection: pw.TextDirection.ltr,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 9,
                      color: PdfColors.blue700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildBulletPoint(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: pw.TextStyle(font: font, fontSize: 10)),
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(font: font, fontSize: 10),
              textAlign: pw.TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
