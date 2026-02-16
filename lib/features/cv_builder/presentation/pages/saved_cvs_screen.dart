import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/presentation/cubit/cv_builder_cubit.dart';
import 'package:seera/features/cv_builder/presentation/cubit/cv_builder_state.dart';
import 'package:seera/features/cv_builder/presentation/pages/review_cv_screen.dart';
import 'package:seera/features/cv_builder/domain/services/pdf_service.dart';
import 'package:printing/printing.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../data/models/cv_model.dart';

class SavedCvsScreen extends StatefulWidget {
  const SavedCvsScreen({super.key});

  @override
  State<SavedCvsScreen> createState() => _SavedCvsScreenState();
}

class _SavedCvsScreenState extends State<SavedCvsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _previewPdf(CVModel cv) async {
    try {
      final pdfService = PdfServiceImpl();
      final file = await pdfService.generatePdf(
        cv,
        AppLocalizations.of(context)!,
      );
      await Printing.layoutPdf(
        onLayout: (format) => file.readAsBytes(),
        name: '${cv.fullName}_CV.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? AppTheme.textMuted : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
        //   onPressed: () => Navigator.maybePop(context),
        // ),
        title: Text(
          loc.resumes, // "My Saved Resumes"
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.blue.withOpacity(0.1),
        //         shape: BoxShape.circle,
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.add, color: AppTheme.primaryBlue),
        //         onPressed: () {
        //           // Navigate to start new chat or manual builder
        //           // context.read<CVBuilderCubit>().setMode(BuilderMode.chat); // Example
        //           // But navigation usually happens from main.dart
        //           Navigator.popUntil(context, (route) => route.isFirst);
        //         },
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: BlocBuilder<CVBuilderCubit, CVBuilderState>(
        builder: (context, state) {
          if (state.savedCVs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: subTextColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.noSavedCVs,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.startChatting,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: subTextColor, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Clear stack and go to main, assuming it lands on selection or chat
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(loc.startNewChat),
                    ),
                  ],
                ),
              ),
            );
          }

          // Filter logic
          final filteredCvs = state.savedCVs.where((cv) {
            final query = _searchQuery.toLowerCase();
            final dateStr = cv.updatedAt != null
                ? DateFormat.yMMMd().format(cv.updatedAt!)
                : '';
            return cv.fullName.toLowerCase().contains(query) ||
                cv.jobTitle.toLowerCase().contains(query) ||
                dateStr.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: loc.searchPlaceholder,
                    hintStyle: TextStyle(color: subTextColor),
                    prefixIcon: Icon(Icons.search, color: subTextColor),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredCvs.isEmpty
                    ? Center(
                        child: Text(
                          loc.noResultsFound,
                          style: TextStyle(color: subTextColor),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredCvs.length,
                        itemBuilder: (context, index) {
                          final cv = filteredCvs[index];
                          final dateStr = cv.updatedAt != null
                              ? DateFormat.yMMMd().format(cv.updatedAt!)
                              : loc.unknownDate;

                          return Dismissible(
                            key: Key(cv.id ?? index.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.redAccent,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              if (cv.id != null) {
                                context.read<CVBuilderCubit>().deleteCV(cv.id!);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor),
                                boxShadow: isDark
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.description,
                                            color: AppTheme.primaryBlue,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cv.jobTitle.isNotEmpty
                                                    ? cv.jobTitle
                                                    : cv.fullName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '$dateStr • ${cv.fullName}',
                                                style: TextStyle(
                                                  color: subTextColor,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: subTextColor,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'delete' &&
                                                cv.id != null) {
                                              context
                                                  .read<CVBuilderCubit>()
                                                  .deleteCV(cv.id!);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    loc.delete,
                                                    style: const TextStyle(
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1, color: borderColor),
                                  Row(
                                    children: [
                                      _buildActionButton(
                                        Icons.visibility_outlined,
                                        loc.view,
                                        () {
                                          context
                                              .read<CVBuilderCubit>()
                                              .updateCV(cv);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewCvScreen(
                                                    messages: const [],
                                                    cvData: cv,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: borderColor,
                                      ),
                                      _buildActionButton(
                                        Icons.edit_note_outlined,
                                        loc.edit.toUpperCase(),
                                        () {
                                          context
                                              .read<CVBuilderCubit>()
                                              .updateCV(cv);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewCvScreen(
                                                    messages: const [],
                                                    cvData: cv,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: borderColor,
                                      ),
                                      _buildActionButton(
                                        Icons.file_download_outlined,
                                        loc.pdf,
                                        () {
                                          _previewPdf(cv);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryBlue),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
