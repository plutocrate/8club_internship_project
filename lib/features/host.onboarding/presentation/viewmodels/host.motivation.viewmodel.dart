import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

enum AudioRecordingPhase { idle, recording }

class AudioRecordingItem {
  final String id;
  final String path;
  final Duration duration;

  const AudioRecordingItem({
    required this.id,
    required this.path,
    required this.duration,
  });

  String get formattedDuration {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class HostMotivationState {
  final String motivationText;
  final AudioRecordingPhase audioPhase;
  final Duration activeRecordingDuration;
  final List<double> waveformAmplitudes;

  final List<AudioRecordingItem> audioRecordings;
  final String? playingAudioId;

  final List<String> videoPaths;

  const HostMotivationState({
    this.motivationText = '',
    this.audioPhase = AudioRecordingPhase.idle,
    this.activeRecordingDuration = Duration.zero,
    this.waveformAmplitudes = const [],
    this.audioRecordings = const [],
    this.playingAudioId,
    this.videoPaths = const [],
  });

  HostMotivationState copyWith({
    String? motivationText,
    AudioRecordingPhase? audioPhase,
    Duration? activeRecordingDuration,
    List<double>? waveformAmplitudes,
    List<AudioRecordingItem>? audioRecordings,
    String? playingAudioId,
    bool clearPlayingAudioId = false,
    List<String>? videoPaths,
  }) {
    return HostMotivationState(
      motivationText: motivationText ?? this.motivationText,
      audioPhase: audioPhase ?? this.audioPhase,
      activeRecordingDuration:
          activeRecordingDuration ?? this.activeRecordingDuration,
      waveformAmplitudes: waveformAmplitudes ?? this.waveformAmplitudes,
      audioRecordings: audioRecordings ?? this.audioRecordings,
      playingAudioId: clearPlayingAudioId
          ? null
          : (playingAudioId ?? this.playingAudioId),
      videoPaths: videoPaths ?? this.videoPaths,
    );
  }

  bool get canProceed =>
      motivationText.trim().isNotEmpty ||
      audioRecordings.isNotEmpty ||
      videoPaths.isNotEmpty;
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
      activeRecordingDuration: Duration.zero,
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
        activeRecordingDuration:
            Duration(seconds: state.activeRecordingDuration.inSeconds + 1),
      );
    });
  }

  Future<void> stopAudioRecording() async {
    _amplitudeSubscription?.cancel();
    _durationTimer?.cancel();

    final path = await _audioRecorder?.stop();
    final duration = state.activeRecordingDuration;
    await _audioRecorder?.dispose();
    _audioRecorder = null;

    if (path != null) {
      final newItem = AudioRecordingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: path,
        duration: duration,
      );
      final updatedList = List<AudioRecordingItem>.from(state.audioRecordings)
        ..add(newItem);

      state = state.copyWith(
        audioPhase: AudioRecordingPhase.idle,
        audioRecordings: updatedList,
        activeRecordingDuration: Duration.zero,
        waveformAmplitudes: [],
      );
    } else {
      state = state.copyWith(
        audioPhase: AudioRecordingPhase.idle,
        activeRecordingDuration: Duration.zero,
        waveformAmplitudes: [],
      );
    }
  }

  Future<void> playAudioRecording(String id, String path) async {
    final file = File(path);
    if (!await file.exists()) return;

    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
      }

      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setFilePath(path);
      await _audioPlayer!.setVolume(1.0);

      _playerStateSubscription?.cancel();
      _playerStateSubscription = _audioPlayer!.playerStateStream.listen((ps) {
        if (ps.processingState == ProcessingState.completed) {
          state = state.copyWith(clearPlayingAudioId: true);
        }
      });

      state = state.copyWith(playingAudioId: id);
      await _audioPlayer!.play();
    } catch (e) {
      state = state.copyWith(clearPlayingAudioId: true);
    }
  }

  Future<void> stopAudioPlayback() async {
    await _audioPlayer?.stop();
    state = state.copyWith(clearPlayingAudioId: true);
  }

  Future<void> deleteAudioRecording(String id) async {
    if (state.playingAudioId == id) {
      await stopAudioPlayback();
    }

    final targetIndex = state.audioRecordings.indexWhere((e) => e.id == id);
    if (targetIndex != -1) {
      final item = state.audioRecordings[targetIndex];
      final file = File(item.path);
      if (await file.exists()) await file.delete();

      final updatedList = List<AudioRecordingItem>.from(state.audioRecordings)
        ..removeAt(targetIndex);

      state = state.copyWith(audioRecordings: updatedList);
    }
  }

  Future<void> recordVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      final updatedList = List<String>.from(state.videoPaths)..add(video.path);
      state = state.copyWith(videoPaths: updatedList);
    }
  }

  Future<void> deleteVideoRecording(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();

    final updatedList = List<String>.from(state.videoPaths)..remove(path);
    state = state.copyWith(videoPaths: updatedList);
  }

  Future<void> resetMotivation() async {
    await stopAudioPlayback();
    for (final audio in state.audioRecordings) {
      final file = File(audio.path);
      if (await file.exists()) await file.delete();
    }
    for (final videoPath in state.videoPaths) {
      final file = File(videoPath);
      if (await file.exists()) await file.delete();
    }
    state = const HostMotivationState();
  }
}

final hostMotivationViewModelProvider =
    StateNotifierProvider<HostMotivationViewModel, HostMotivationState>((ref) {
  return HostMotivationViewModel();
});
