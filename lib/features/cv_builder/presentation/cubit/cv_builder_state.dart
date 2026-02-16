import 'package:seera/features/cv_builder/data/models/cv_model.dart';

enum BuilderMode { chat, manual }

class CVBuilderState {
  final CVModel currentCv;
  final List<CVModel> savedCVs;
  final BuilderMode mode;
  final bool isLoading;
  final String? error;

  CVBuilderState({
    required this.currentCv,
    this.savedCVs = const [],
    this.mode = BuilderMode.chat,
    this.isLoading = false,
    this.error,
  });

  CVBuilderState copyWith({
    CVModel? currentCv,
    List<CVModel>? savedCVs,
    BuilderMode? mode,
    bool? isLoading,
    String? error,
  }) {
    return CVBuilderState(
      currentCv: currentCv ?? this.currentCv,
      savedCVs: savedCVs ?? this.savedCVs,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory CVBuilderState.initial() {
    return CVBuilderState(
      currentCv: CVModel(
        fullName: '',
        jobTitle: '',
        email: '',
        phone: '',
        country: '',
        city: '',
        // targetCountry: '',
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
      ),
      savedCVs: [],
    );
  }
}
