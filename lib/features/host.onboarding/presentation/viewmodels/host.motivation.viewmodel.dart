import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

enum AudioRecordingPhase { idle, recording, recorded }

class HostMotivationState {
  final String motivationText;
  final AudioRecordingPhase audioPhase;
  final String? audioPath;
  final Duration recordingDuration;
  final List<double> waveformAmplitudes;
  final bool isPlayingAudio;
  final String? videoPath;

  const HostMotivationState({
    this.motivationText = '',
    this.audioPhase = AudioRecordingPhase.idle,
    this.audioPath,
    this.recordingDuration = Duration.zero,
    this.waveformAmplitudes = const [],
    this.isPlayingAudio = false,
    this.videoPath,
  });

  HostMotivationState copyWith({
    String? motivationText,
    AudioRecordingPhase? audioPhase,
    String? audioPath,
    Duration? recordingDuration,
    List<double>? waveformAmplitudes,
    bool? isPlayingAudio,
    String? videoPath,
    bool clearAudioPath = false,
    bool clearVideoPath = false,
  }) {
    return HostMotivationState(
      motivationText: motivationText ?? this.motivationText,
      audioPhase: audioPhase ?? this.audioPhase,
      audioPath: clearAudioPath ? null : (audioPath ?? this.audioPath),
      recordingDuration: recordingDuration ?? this.recordingDuration,
      waveformAmplitudes: waveformAmplitudes ?? this.waveformAmplitudes,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      videoPath: clearVideoPath ? null : (videoPath ?? this.videoPath),
    );
  }

  bool get hasAudio => audioPhase == AudioRecordingPhase.recorded;
  bool get hasVideo => videoPath != null;

  bool get canProceed =>
      motivationText.trim().isNotEmpty || hasAudio || hasVideo;

  String get formattedDuration {
    final minutes = recordingDuration.inMinutes.remainder(60);
    final seconds = recordingDuration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class HostMotivationViewModel extends StateNotifier<HostMotivationState> {
  AudioRecorder? _audioRecorder;
  AudioPlayer? _audioPlayer;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  StreamSubscription? _playerStateSubscription;
  Timer? _durationTimer;

  HostMotivationViewModel() : super(const HostMotivationState());

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  void _disposeResources() {
    _amplitudeSubscription?.cancel();
    _durationTimer?.cancel();
    _playerStateSubscription?.cancel();
    _audioRecorder?.dispose();
    _audioPlayer?.dispose();
  }

  void updateMotivationText(String text) {
    state = state.copyWith(motivationText: text);
  }

  Future<void> startAudioRecording() async {
    if (state.hasAudio) return; // Only 1 audio allowed

    final micPermission = await Permission.microphone.request();
    if (!micPermission.isGranted) return;

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _audioRecorder = AudioRecorder();

    await _audioRecorder!.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 44100, bitRate: 128000),
      path: path,
    );

    _amplitudeSubscription = _audioRecorder!
        .onAmplitudeChanged(const Duration(milliseconds: 150))
        .listen(_handleAmplitude);

    _startDurationTimer();

    state = state.copyWith(
      audioPhase: AudioRecordingPhase.recording,
      recordingDuration: Duration.zero,
      waveformAmplitudes: [],
    );
  }

  void _handleAmplitude(Amplitude amplitude) {
    final normalized = _normalizeDbfs(amplitude.current);
    final updated = List<double>.from(state.waveformAmplitudes)..add(normalized);
    if (updated.length > 30) updated.removeAt(0);
    state = state.copyWith(waveformAmplitudes: updated);
  }

  double _normalizeDbfs(double dBFS) {
    const minDb = -60.0;
    if (dBFS <= minDb) return 0.08;
    final normalized = ((dBFS - minDb) / minDb.abs()).clamp(0.08, 1.0);
    return normalized;
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        recordingDuration:
            Duration(seconds: state.recordingDuration.inSeconds + 1),
      );
    });
  }

  Future<void> stopAudioRecording() async {
    _amplitudeSubscription?.cancel();
    _durationTimer?.cancel();

    final path = await _audioRecorder?.stop();
    await _audioRecorder?.dispose();
    _audioRecorder = null;

    state = state.copyWith(
      audioPhase: AudioRecordingPhase.recorded,
      audioPath: path,
    );
  }

  Future<void> playAudioRecording() async {
    if (state.audioPath == null) return;
    final file = File(state.audioPath!);
    if (!await file.exists()) return;

    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
      }

      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setFilePath(state.audioPath!);
      await _audioPlayer!.setVolume(1.0);

      _playerStateSubscription?.cancel();
      _playerStateSubscription = _audioPlayer!.playerStateStream.listen((ps) {
        if (ps.processingState == ProcessingState.completed) {
          state = state.copyWith(isPlayingAudio: false);
        }
      });

      state = state.copyWith(isPlayingAudio: true);
      await _audioPlayer!.play();
    } catch (e) {
      state = state.copyWith(isPlayingAudio: false);
    }
  }

  Future<void> stopAudioPlayback() async {
    await _audioPlayer?.stop();
    state = state.copyWith(isPlayingAudio: false);
  }

  Future<void> deleteAudioRecording() async {
    await stopAudioPlayback();
    await _audioPlayer?.dispose();
    _audioPlayer = null;

    if (state.audioPath != null) {
      final file = File(state.audioPath!);
      if (await file.exists()) await file.delete();
    }

    state = state.copyWith(
      audioPhase: AudioRecordingPhase.idle,
      clearAudioPath: true,
      recordingDuration: Duration.zero,
      waveformAmplitudes: [],
      isPlayingAudio: false,
    );
  }

  Future<void> recordVideo() async {
    if (state.hasVideo) return; // Only 1 video allowed

    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      state = state.copyWith(videoPath: video.path);
    }
  }

  Future<void> deleteVideoRecording() async {
    if (state.videoPath != null) {
      final file = File(state.videoPath!);
      if (await file.exists()) await file.delete();
    }
    state = state.copyWith(clearVideoPath: true);
  }

  Future<void> resetMotivation() async {
    await deleteAudioRecording();
    await deleteVideoRecording();
    state = const HostMotivationState();
  }
}

final hostMotivationViewModelProvider =
    StateNotifierProvider<HostMotivationViewModel, HostMotivationState>((ref) {
  return HostMotivationViewModel();
});
