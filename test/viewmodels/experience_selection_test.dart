import 'package:flutter_test/flutter_test.dart';
import 'package:eightclub/features/host.onboarding/presentation/viewmodels/experience.selection.viewmodel.dart';

void main() {
  group('ExperienceSelectionViewModel Tests', () {
    late ExperienceSelectionViewModel viewModel;

    setUp(() {
      viewModel = ExperienceSelectionViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial state has no selected stamps and cannot proceed', () {
      expect(viewModel.state.selectedIds, isEmpty);
      expect(viewModel.state.description, isEmpty);
      expect(viewModel.state.canProceed, isFalse);
    });

    test('Toggling stamp selection updates state and enables canProceed', () {
      viewModel.toggleExperience(23); // Party
      expect(viewModel.state.selectedIds, contains(23));
      expect(viewModel.state.canProceed, isTrue);

      viewModel.toggleExperience(23); // Toggle off
      expect(viewModel.state.selectedIds, isNot(contains(23)));
      expect(viewModel.state.canProceed, isFalse);
    });

    test('Updating description saves text in state', () {
      viewModel.updateDescription('Cocktails & House Music');
      expect(viewModel.state.description, equals('Cocktails & House Music'));
    });

    test('Maximum 5 cards limit is enforced', () {
      for (int i = 1; i <= 6; i++) {
        viewModel.toggleExperience(i);
      }
      expect(viewModel.state.selectedIds.length, equals(5));
      expect(viewModel.state.selectedIds, containsAll([1, 2, 3, 4, 5]));
      expect(viewModel.state.selectedIds, isNot(contains(6)));
    });

    test('resetSelection clears all selected stamps and description', () {
      viewModel.toggleExperience(23);
      viewModel.updateDescription('Test text');
      expect(viewModel.state.canProceed, isTrue);

      viewModel.resetSelection();
      expect(viewModel.state.selectedIds, isEmpty);
      expect(viewModel.state.description, isEmpty);
      expect(viewModel.state.canProceed, isFalse);
    });
  });
}
