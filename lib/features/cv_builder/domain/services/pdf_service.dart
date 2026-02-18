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
  // ── Palette ───────────────────────────────────────────────────────────────
  static const PdfColor _black = PdfColors.black;
  static const PdfColor _titleColor = PdfColor.fromInt(0xFF2563EB);
  static const PdfColor _mutedColor = PdfColor.fromInt(0xFF4B5563);
  static const PdfColor _linkColor = PdfColor.fromInt(0xFF2563EB);
  static const PdfColor _dotColor = PdfColor.fromInt(0xFF9CA3AF);
  static const PdfColor _bulletColor = PdfColor.fromInt(0xFF374151);

  // ══════════════════════════════════════════════════════════════════════════
  // DIRECTION LOGIC
  //
  // Priority order:
  //   1. App language (loc.localeName) → sets the document base direction
  //   2. Individual field content     → overrides per-text when needed
  //
  // Rules:
  //   • App = Arabic  + text = Arabic   → RTL  (normal Arabic CV)
  //   • App = Arabic  + text = English  → LTR  (e.g. company names in English)
  //   • App = English + text = Arabic   → RTL  (user typed Arabic in English app)
  //   • App = English + text = English  → LTR  (normal English CV)
  // ══════════════════════════════════════════════════════════════════════════

  /// True when the app is currently set to Arabic
  bool _appIsArabic(AppLocalizations loc) => loc.localeName.startsWith('ar');

  /// True if [text] contains Arabic characters
  bool _isArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  /// Resolve the text direction for a specific piece of text,
  /// always taking both the app language AND the text content into account.
  pw.TextDirection _dirFor(String text, bool appRtl) {
    if (_isArabic(text)) return pw.TextDirection.rtl;
    // If app is Arabic but the text is Latin (e.g. "Flutter Developer"),
    // force LTR so it renders correctly inside an RTL document.
    return pw.TextDirection.ltr;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TEXT HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  /// The single function used to render ALL user-entered text.
  /// Automatically picks the right direction for both the app locale
  /// and the actual text content.
  pw.Widget _t(
    String text,
    pw.TextStyle style,
    bool appRtl, {
    pw.TextAlign? textAlign,
  }) {
    if (text.isEmpty) return pw.SizedBox();
    final dir = _dirFor(text, appRtl);
    final isRtl = dir == pw.TextDirection.rtl;
    return pw.Directionality(
      textDirection: dir,
      child: pw.Text(
        text,
        style: style,
        textDirection: dir,
        textAlign:
            textAlign ?? (isRtl ? pw.TextAlign.right : pw.TextAlign.left),
      ),
    );
  }

  /// Date strings (e.g. "2020 – 2023") are ALWAYS LTR regardless of app language
  pw.Widget _date(String text, pw.Font font) {
    if (text.isEmpty) return pw.SizedBox();
    return pw.Text(
      text,
      style: pw.TextStyle(font: font, fontSize: 9, color: _mutedColor),
      textDirection: pw.TextDirection.ltr,
    );
  }

  pw.TextStyle _bodyStyle(pw.Font font) =>
      pw.TextStyle(font: font, fontSize: 10, lineSpacing: 1.4, color: _black);

  pw.TextStyle _mutedStyle(pw.Font font, {double size = 10}) => pw.TextStyle(
    font: font,
    fontSize: size,
    lineSpacing: 1.3,
    color: _mutedColor,
  );

  pw.TextStyle _boldStyle(pw.Font font, {double size = 10.5}) =>
      pw.TextStyle(font: font, fontSize: size, color: _black);

  pw.Widget _gap(double h) => pw.SizedBox(height: h);

  // ══════════════════════════════════════════════════════════════════════════
  // MAIN
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<File> generatePdf(CVModel data, AppLocalizations loc) async {
    final pdf = pw.Document();
    final regular = await PdfGoogleFonts.cairoRegular();
    final bold = await PdfGoogleFonts.cairoBold();

    // ── Document-level direction comes from the APP LANGUAGE ────────────────
    final appRtl = _appIsArabic(loc);
    final docDir = appRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    final docCross = appRtl
        ? pw.CrossAxisAlignment.end
        : pw.CrossAxisAlignment.start;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(48, 40, 48, 40),
        build: (context) => [
          pw.Directionality(
            textDirection: docDir,
            child: pw.Column(
              crossAxisAlignment: docCross,
              children: [
                // ── HEADER ──────────────────────────────────────────
                _buildHeader(data, regular, bold, appRtl),
                _gap(14),

                // ── SUMMARY ─────────────────────────────────────────
                if (data.summary.isNotEmpty) ...[
                  _buildSection(
                    title: loc.summaryLabel,
                    bold: bold,
                    appRtl: appRtl,
                    child: _t(data.summary, _bodyStyle(regular), appRtl),
                  ),
                  _gap(12),
                ],

                // ── EXPERIENCE ──────────────────────────────────────
                if (data.experience.isNotEmpty) ...[
                  _buildSection(
                    title: loc.experienceSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: pw.Column(
                      crossAxisAlignment: docCross,
                      children: data.experience
                          .map(
                            (e) => _buildExperience(e, regular, bold, appRtl),
                          )
                          .toList(),
                    ),
                  ),
                  _gap(12),
                ],

                // ── EDUCATION ───────────────────────────────────────
                if (data.education.isNotEmpty) ...[
                  _buildSection(
                    title: loc.educationSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: pw.Column(
                      crossAxisAlignment: docCross,
                      children: data.education
                          .map((e) => _buildEducation(e, regular, bold, appRtl))
                          .toList(),
                    ),
                  ),
                  _gap(12),
                ],

                // ── PROJECTS ────────────────────────────────────────
                if (data.projects.isNotEmpty) ...[
                  _buildSection(
                    title: loc.projectsSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: pw.Column(
                      crossAxisAlignment: docCross,
                      children: data.projects
                          .map((p) => _buildProject(p, regular, bold, appRtl))
                          .toList(),
                    ),
                  ),
                  _gap(12),
                ],

                // ── SKILLS ──────────────────────────────────────────
                if (data.skills.isNotEmpty) ...[
                  _buildSection(
                    title: loc.skillsSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: _buildSkills(data.skills, regular, appRtl),
                  ),
                  _gap(12),
                ],

                // ── LANGUAGES ───────────────────────────────────────
                if (data.languages.isNotEmpty) ...[
                  _buildSection(
                    title: loc.languagesSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: _buildLanguages(
                      data.languages,
                      regular,
                      bold,
                      appRtl,
                    ),
                  ),
                  _gap(12),
                ],

                // ── CUSTOM SECTIONS ─────────────────────────────────
                ...data.customSections.map(
                  (s) => pw.Column(
                    crossAxisAlignment: docCross,
                    children: [
                      _buildSection(
                        title: s.title,
                        bold: bold,
                        appRtl: appRtl,
                        child: _t(s.content, _bodyStyle(regular), appRtl),
                      ),
                      _gap(12),
                    ],
                  ),
                ),

                // ── ADDITIONAL INFO ─────────────────────────────────
                if (data.additionalInfo.isNotEmpty)
                  _buildSection(
                    title: loc.additionalInfoSection,
                    bold: bold,
                    appRtl: appRtl,
                    child: _t(data.additionalInfo, _bodyStyle(regular), appRtl),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    // Safe filename — handles Arabic names (which strip to empty)
    final dir = await getTemporaryDirectory();
    final safe = data.fullName
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();
    final fileName = safe.isEmpty ? 'CV' : safe;
    final file = File('${dir.path}/${fileName}_CV.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildHeader(
    CVModel data,
    pw.Font regular,
    pw.Font bold,
    bool appRtl,
  ) {
    // Arabic has no uppercase concept
    final displayName = _isArabic(data.fullName)
        ? data.fullName
        : data.fullName.toUpperCase();

    // Build contact chips — each chip resolves its own direction
    // (city may be Arabic even in an English CV, or vice-versa)
    final contactParts = <String>[
      if (data.email.isNotEmpty) data.email,
      if (data.phone.isNotEmpty) data.phone,
      if (data.city.isNotEmpty) '${data.city}, ${data.country}',
      if (data.linkedin.isNotEmpty) data.linkedin,
      if (data.github.isNotEmpty) data.github,
    ];

    final chips = <pw.Widget>[];
    for (var i = 0; i < contactParts.length; i++) {
      final part = contactParts[i];
      final chipDir = _dirFor(part, appRtl);
      chips.add(
        pw.Directionality(
          textDirection: chipDir,
          child: pw.Text(
            part,
            style: pw.TextStyle(font: regular, fontSize: 9, color: _mutedColor),
            textDirection: chipDir,
          ),
        ),
      );
      if (i < contactParts.length - 1) {
        chips.add(
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 5),
            child: pw.Text(
              '\u00B7',
              style: pw.TextStyle(font: regular, fontSize: 9, color: _dotColor),
            ),
          ),
        );
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Center(
          child: _t(
            displayName,
            pw.TextStyle(
              font: bold,
              fontSize: 22,
              letterSpacing: _isArabic(data.fullName) ? 0 : 1.8,
              color: _black,
            ),
            appRtl,
          ),
        ),
        _gap(3),
        pw.Center(
          child: _t(
            data.jobTitle,
            pw.TextStyle(
              font: regular,
              fontSize: 12,
              color: _titleColor,
              letterSpacing: _isArabic(data.jobTitle) ? 0 : 0.3,
            ),
            appRtl,
          ),
        ),
        _gap(8),
        if (chips.isNotEmpty)
          pw.Center(
            child: pw.Wrap(
              alignment: pw.WrapAlignment.center,
              crossAxisAlignment: pw.WrapCrossAlignment.center,
              children: chips,
            ),
          ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION WRAPPER
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildSection({
    required String title,
    required pw.Font bold,
    required bool appRtl,
    required pw.Widget child,
  }) {
    // Section titles come from loc (app strings), so they follow app direction.
    // But if a custom section title is typed in Arabic, respect that too.
    final titleIsArabic = _isArabic(title);
    final displayTitle = titleIsArabic ? title : title.toUpperCase();

    return pw.Column(
      crossAxisAlignment: appRtl
          ? pw.CrossAxisAlignment.end
          : pw.CrossAxisAlignment.start,
      children: [
        _t(
          displayTitle,
          pw.TextStyle(
            font: bold,
            fontSize: 10.5,
            // letterSpacing breaks Arabic ligatures — only use for Latin
            letterSpacing: titleIsArabic ? 0 : 1.4,
            color: _black,
          ),
          appRtl,
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 2, bottom: 8),
          height: 0.8,
          color: _black,
        ),
        child,
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EXPERIENCE
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildExperience(
    ExperienceModel exp,
    pw.Font regular,
    pw.Font bold,
    bool appRtl,
  ) {
    // Duration & location are always LTR (numbers/city names in any language)
    final dateW = _date(exp.duration, regular);
    final locW = exp.location.isNotEmpty
        ? pw.Text(
            exp.location,
            style: _mutedStyle(regular, size: 9),
            // Location: respect its own content direction
            textDirection: _dirFor(exp.location, appRtl),
          )
        : null;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: appRtl
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,
        children: [
          // Row 1: Company  ←→  Duration
          // In RTL: Duration on LEFT, Company on RIGHT
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: appRtl
                ? [
                    dateW,
                    pw.Expanded(
                      child: _t(exp.company, _boldStyle(bold), appRtl),
                    ),
                  ]
                : [
                    pw.Expanded(
                      child: _t(exp.company, _boldStyle(bold), appRtl),
                    ),
                    dateW,
                  ],
          ),

          // Row 2: Job title  ←→  Location
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: appRtl
                ? [
                    if (locW != null) locW,
                    _t(exp.jobTitle, _mutedStyle(regular), appRtl),
                  ]
                : [
                    _t(exp.jobTitle, _mutedStyle(regular), appRtl),
                    if (locW != null) locW,
                  ],
          ),

          // Responsibilities
          if (exp.responsibilities.isNotEmpty) ...[
            _gap(4),
            ...exp.responsibilities.map((r) => _bullet(r, regular, appRtl)),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EDUCATION
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildEducation(
    EducationModel edu,
    pw.Font regular,
    pw.Font bold,
    bool appRtl,
  ) {
    final dateW = _date(edu.dateRange, regular);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: appRtl
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: appRtl
                ? [
                    dateW,
                    pw.Expanded(
                      child: _t(edu.degree, _boldStyle(bold), appRtl),
                    ),
                  ]
                : [
                    pw.Expanded(
                      child: _t(edu.degree, _boldStyle(bold), appRtl),
                    ),
                    dateW,
                  ],
          ),
          _t(edu.institution, _mutedStyle(regular), appRtl),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROJECTS
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildProject(
    ProjectModel proj,
    pw.Font regular,
    pw.Font bold,
    bool appRtl,
  ) {
    final linkWidget = proj.url.isNotEmpty
        ? pw.UrlLink(
            destination: proj.url,
            child: pw.Text(
              'Link',
              style: pw.TextStyle(
                font: regular,
                fontSize: 8.5,
                color: _linkColor,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          )
        : null;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: appRtl
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,
        children: [
          // Title + Link — link stays on the "outer" side
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: appRtl
                ? [
                    if (linkWidget != null) ...[
                      linkWidget,
                      pw.SizedBox(width: 8),
                    ],
                    pw.Expanded(
                      child: _t(proj.title, _boldStyle(bold), appRtl),
                    ),
                  ]
                : [
                    _t(proj.title, _boldStyle(bold), appRtl),
                    if (linkWidget != null) ...[
                      pw.SizedBox(width: 8),
                      linkWidget,
                    ],
                  ],
          ),
          if (proj.role.isNotEmpty) ...[
            _gap(2),
            _t(proj.role, _mutedStyle(regular, size: 9.5), appRtl),
          ],
          if (proj.description.isNotEmpty) ...[
            _gap(3),
            _t(proj.description, _bodyStyle(regular), appRtl),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SKILLS
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildSkills(List<String> skills, pw.Font regular, bool appRtl) {
    const cols = 4;
    final rows = <List<String>>[];
    for (var i = 0; i < skills.length; i += cols) {
      final end = (i + cols < skills.length) ? i + cols : skills.length;
      rows.add(skills.sublist(i, end));
    }

    return pw.Column(
      crossAxisAlignment: appRtl
          ? pw.CrossAxisAlignment.end
          : pw.CrossAxisAlignment.start,
      children: rows.map((row) {
        // In RTL documents: reverse the row so items flow right→left
        final displayRow = appRtl ? row.reversed.toList() : row;
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: displayRow
              .map((s) => pw.Expanded(child: _bullet(s, regular, appRtl)))
              .toList(),
        );
      }).toList(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGES
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _buildLanguages(
    List<LanguageModel> languages,
    pw.Font regular,
    pw.Font bold,
    bool appRtl,
  ) {
    return pw.Wrap(
      spacing: 24,
      runSpacing: 6,
      children: languages.map((l) {
        // Each language entry: name and level may have different directions
        // e.g. "العربية: Native" or "English: متوسط"
        final nameRtl = _isArabic(l.name);
        final levelRtl = _isArabic(l.level);

        return pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: appRtl
              // Arabic app: level  :  name  (right-to-left reading)
              ? [
                  pw.Text(
                    l.level,
                    style: _mutedStyle(regular),
                    textDirection: levelRtl
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                  ),
                  pw.Text(
                    ' : ',
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 10,
                      color: _black,
                    ),
                  ),
                  pw.Text(
                    l.name,
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 10,
                      color: _black,
                    ),
                    textDirection: nameRtl
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                  ),
                ]
              // English app: name :  level  (left-to-right reading)
              : [
                  pw.Text(
                    l.name,
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 10,
                      color: _black,
                    ),
                    textDirection: nameRtl
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                  ),
                  pw.Text(
                    ': ',
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 10,
                      color: _black,
                    ),
                  ),
                  pw.Text(
                    l.level,
                    style: _mutedStyle(regular),
                    textDirection: levelRtl
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                  ),
                ],
        );
      }).toList(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BULLET
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _bullet(String text, pw.Font font, bool appRtl) {
    final textDir = _dirFor(text, appRtl);
    final isRtl = textDir == pw.TextDirection.rtl;

    return pw.Padding(
      padding: pw.EdgeInsets.only(
        left: isRtl ? 0 : 2,
        right: isRtl ? 2 : 0,
        bottom: 2,
      ),
      child: pw.Directionality(
        textDirection: textDir,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '\u2022 ',
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                color: _bulletColor,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                text,
                style: _bodyStyle(font),
                textDirection: textDir,
                textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
