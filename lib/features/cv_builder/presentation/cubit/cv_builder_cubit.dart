import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'cv_builder_state.dart';

class CVBuilderCubit extends Cubit<CVBuilderState> {
  CVBuilderCubit() : super(CVBuilderState.initial()) {
    loadSavedCVs();
    _loadDraftCV();
  }

  void setMode(BuilderMode mode) {
    emit(state.copyWith(mode: mode));
  }

  void updateCV(CVModel cv) {
    emit(state.copyWith(currentCv: cv));
    _saveDraftCV();
  }

  void updateField({
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
    String? linkedin,
    String? github,
    List<CustomSectionModel>? customSections,
    String? additionalInfo,
  }) {
    emit(
      state.copyWith(
        currentCv: state.currentCv.copyWith(
          fullName: fullName,
          jobTitle: jobTitle,
          email: email,
          phone: phone,
          country: country,
          city: city,
          // targetCountry: targetCountry,
          summary: summary,
          skills: skills,
          experience: experience,
          education: education,
          languages: languages,
          projects: projects,
          linkedin: linkedin,
          github: github,
          customSections: customSections,
          additionalInfo: additionalInfo,
        ),
      ),
    );
    _saveDraftCV();
  }

  void reorderExperience(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final items = List<ExperienceModel>.from(state.currentCv.experience);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    updateCV(state.currentCv.copyWith(experience: items));
  }

  Future<void> _loadDraftCV() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? draftJson = prefs.getString('draft_cv');
      if (draftJson != null) {
        emit(
          state.copyWith(currentCv: CVModel.fromJson(jsonDecode(draftJson))),
        );
      }
    } catch (e) {
      print('Error loading draft CV: $e');
    }
  }

  Future<void> _saveDraftCV() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('draft_cv', jsonEncode(state.currentCv.toJson()));
    } catch (e) {
      print('Error saving draft CV: $e');
    }
  }

  Future<void> loadSavedCVs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? cvsJson = prefs.getStringList('saved_cvs');
      if (cvsJson != null) {
        final List<CVModel> cvs = cvsJson
            .map((str) => CVModel.fromJson(jsonDecode(str)))
            .toList();

        // Sort by updatedAt descending
        cvs.sort((a, b) {
          final aDate = a.updatedAt ?? DateTime(2000);
          final bDate = b.updatedAt ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });

        emit(state.copyWith(savedCVs: cvs));
      }
    } catch (e) {
      // Handle error cleanly, maybe clear corrupt data
      print('Error loading CVs: $e');
    }
  }

  Future<void> saveCurrentCV() async {
    final prefs = await SharedPreferences.getInstance();
    final List<CVModel> currentSaved = List.from(state.savedCVs);

    // Create new CV instance with ID and Timestamp if missing or update existing
    final now = DateTime.now();
    CVModel cvToSave = state.currentCv;

    if (cvToSave.id == null || cvToSave.id!.isEmpty) {
      cvToSave = cvToSave.copyWith(
        id: now.millisecondsSinceEpoch.toString(),
        updatedAt: now,
      );
    } else {
      cvToSave = cvToSave.copyWith(updatedAt: now);
    }

    // Check if we are updating an existing one in the list
    final existingIndex = currentSaved.indexWhere((c) => c.id == cvToSave.id);
    if (existingIndex >= 0) {
      currentSaved[existingIndex] = cvToSave;
    } else {
      currentSaved.insert(0, cvToSave);
    }

    final List<String> cvsJson = currentSaved
        .map((cv) => jsonEncode(cv.toJson()))
        .toList();

    await prefs.setStringList('saved_cvs', cvsJson);
    emit(state.copyWith(savedCVs: currentSaved, currentCv: cvToSave));
    _saveDraftCV();
  }

  Future<void> deleteCV(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CVModel> currentSaved = List.from(state.savedCVs);
    currentSaved.removeWhere((c) => c.id == id);

    final List<String> cvsJson = currentSaved
        .map((cv) => jsonEncode(cv.toJson()))
        .toList();

    await prefs.setStringList('saved_cvs', cvsJson);
    emit(state.copyWith(savedCVs: currentSaved));
  }

  void resetCV() async {
    emit(state.copyWith(currentCv: CVModel.initial()));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_cv');
  }
}
