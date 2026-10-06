# 8club Host Onboarding App

A Flutter application built for the **8club Host Onboarding** experience, crafted with rich dark-mode aesthetics, continuous curved geometry, real-time waveform visualization, and clean **Bifrost Architecture**.

---

## Key Features

- **Dynamic Experience Stamp Selector**: Fetches available experience stamps dynamically from the 8club API (`/v1/experiences`) with automatic offline mock fallback and smooth shimmering loading states. Multi-selection support with dark elevation & neon border highlights.
- **Continuous Rectangular Geometry**: Custom continuous rounded corners (`ContinuousRectangleBorder`) across all buttons, cards, text fields, and stamps for smooth visual curvature matching 8club's design language.
- **Space Grotesk Typography**: Comprehensive typography scale mapped directly from Figma tokens (`H1` through `S2`).
- **Media Integration**:
  - Live audio recording using `record` package.
  - Real-time animated waveform visualizer reacting to microphone amplitude levels.
  - Audio playback controls (`just_audio`) with duration tracking and delete flow.
  - Camera video recording integration using `image_picker`.

---

## Architecture (Bifrost Standard)

The codebase strictly adheres to the **Bifrost Architecture** guidelines:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app.colors.dart
│   │   └── app.text.styles.dart
│   ├── network/
│   │   └── dio.client.dart
│   └── theme/
│       └── app.theme.dart
└── features/
    └── host.onboarding/
        ├── data/
        │   ├── models/
        │   │   └── experience.model.dart
        │   └── repositories/
        │       └── experience.repository.dart
        └── presentation/
            ├── pages/
            │   ├── experience.selection.page.dart
            │   ├── host.motivation.page.dart
            │   └── onboarding.completion.page.dart
            ├── providers/
            │   └── experiences.provider.dart
            ├── viewmodels/
            │   ├── experience.selection.viewmodel.dart
            │   └── host.motivation.viewmodel.dart
            └── widgets/
                ├── audio.player.bar.widget.dart
                ├── audio.recorder.bar.widget.dart
                ├── continuous.button.widget.dart
                ├── experience.stamp.widget.dart
                ├── onboarding.progress.bar.widget.dart
                ├── shimmer.stamp.widget.dart
                ├── video.player.bar.widget.dart
                └── waveform.visualizer.widget.dart
```

### Architectural Principles Applied

1. **Separation of Concerns**: UI widgets are pure renderers (`ConsumerWidget`). Zero business logic or HTTP calls in widgets.
2. **State Management**: Riverpod (`Notifier` / `AsyncNotifier`) with code generation (`riverpod_annotation`).
3. **Data Layer**: Repositories abstract API endpoints via Dio. Network failures automatically fall back to mock data.
4. **Asynchronous UI**: UI rendering leverages `AsyncValue.when` for elegant state handling (Loading shimmer → Data → Error).
5. **Modularity**: Strict file length hygiene (maximum ~200 lines per file) and dot-separated naming convention (`experience.stamp.widget.dart`).

---

## Getting Started

### Prerequisites

- Flutter SDK (3.19.0 or higher)
- Dart SDK (3.3.0 or higher)
- Android Studio / Xcode (for device/emulator execution)

### Installation & Execution

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd eightclub
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (if modifying models/providers):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Launch the app:
   ```bash
   flutter run
   ```

---

## Technical Trade-offs & Decisions

- **Local Storage for Media**: Audio and video clips recorded during onboarding are stored in the device's temporary directory for playback. Upload endpoints can be plugged directly into `HostMotivationViewModel`.
- **Amplitude Normalization**: Real-time microphone amplitude (`dBFS`) is normalized into a `[0.08, 1.0]` scale to drive the custom waveform bar height smooth animations.
