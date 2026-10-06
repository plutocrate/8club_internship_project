import 'package:flutter_test/flutter_test.dart';
import 'package:eightclub/features/host.onboarding/presentation/viewmodels/host.motivation.viewmodel.dart';

void main() {
  group('HostMotivationViewModel Tests', () {
    late HostMotivationViewModel viewModel;

    setUp(() {
      viewModel = HostMotivationViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial state is idle and cannot proceed', () {
      expect(viewModel.state.motivationText, isEmpty);
      expect(viewModel.state.audioPhase, equals(AudioRecordingPhase.idle));
      expect(viewModel.state.hasAudio, isFalse);
      expect(viewModel.state.hasVideo, isFalse);
      expect(viewModel.state.canProceed, isFalse);
    });

    test('Updating motivation text enables canProceed', () {
      viewModel.updateMotivationText('I want to bring people together!');
      expect(viewModel.state.motivationText, equals('I want to bring people together!'));
      expect(viewModel.state.canProceed, isTrue);
    });

    test('resetMotivation clears state completely', () async {
      viewModel.updateMotivationText('Test intent');
      expect(viewModel.state.canProceed, isTrue);

      await viewModel.resetMotivation();
      expect(viewModel.state.motivationText, isEmpty);
      expect(viewModel.state.canProceed, isFalse);
    });
  });
}
