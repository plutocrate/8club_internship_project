import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceSelectionState {
  final Set<int> selectedIds;
  final String description;

  const ExperienceSelectionState({
    this.selectedIds = const {},
    this.description = '',
  });

  ExperienceSelectionState copyWith({
    Set<int>? selectedIds,
    String? description,
  }) {
    return ExperienceSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
      description: description ?? this.description,
    );
  }

  // Must select at least 1 card to proceed (text alone does not enable Next)
  bool get canProceed => selectedIds.isNotEmpty;
}

class ExperienceSelectionViewModel
    extends StateNotifier<ExperienceSelectionState> {
  ExperienceSelectionViewModel() : super(const ExperienceSelectionState());

  void toggleExperience(int experienceId) {
    final updated = Set<int>.from(state.selectedIds);
    if (updated.contains(experienceId)) {
      updated.remove(experienceId);
    } else {
      updated.add(experienceId);
    }
    state = state.copyWith(selectedIds: updated);
  }

  void updateDescription(String text) {
    state = state.copyWith(description: text);
  }
}

final experienceSelectionViewModelProvider = StateNotifierProvider<
    ExperienceSelectionViewModel, ExperienceSelectionState>((ref) {
  return ExperienceSelectionViewModel();
});
