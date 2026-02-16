import 'dart:convert';
import 'package:printing/printing.dart';
import 'package:seera/core/services/ai_service.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/features/cv_builder/domain/services/pdf_service.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

class CvHandler {
  final ChatService _aiService;
  final PdfService _pdfService;

  CvHandler(this._aiService, {PdfService? pdfService})
    : _pdfService = pdfService ?? PdfServiceImpl();

  bool canGenerate(List<String> messages) {
    final history = messages.join('\n').toLowerCase();
    final hasName = history.contains('اسم') || history.contains('name');
    final hasEmail = history.contains('@');
    final hasPhone = history.contains('01') || history.contains('+');
    final hasJobTitle =
        history.contains('مسمى') ||
        history.contains('عنوان') ||
        history.contains('job');

    return hasName && hasEmail && hasPhone && hasJobTitle;
  }

  Future<CVModel> generateCV(List<String> messages) async {
    final jsonString = await _aiService.generateCV(messages);

    final cleanJson = jsonString
        .replaceAll('```json', '')
        .replaceAll('```', '');

    final Map<String, dynamic> jsonData = jsonDecode(cleanJson);
    return CVModel.fromJson(jsonData);
  }

  Future<void> generateAndPrintPdf(
    CVModel cvData,
    AppLocalizations l10n,
  ) async {
    final file = await _pdfService.generatePdf(cvData, l10n);
    await Printing.layoutPdf(
      onLayout: (format) => file.readAsBytes(),
      name: '${cvData.fullName}_Seera_CV.pdf',
    );
  }
}
