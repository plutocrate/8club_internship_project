# 8club Host Onboarding — Codebase Reference & Architectural Deep Dive

This document serves as an exhaustive reference explaining the codebase design, architecture, dependencies, state management patterns, design tokens, and technical choices implemented in the project.

---

## 1. High-Level Architecture Overview

The app is built following **Bifrost Architecture**, a clean architecture pattern tailored for Flutter apps. The primary goal is to isolate business logic, network communication, and UI rendering into distinct layers.

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│  (ConsumerWidget / Dumb Renderers / Dot-named files)    │
└───────────────────────────┬─────────────────────────────┘
                            │ Watches State
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   ViewModel Layer                       │
│     (Riverpod Notifiers / Business Logic / State)       │
└───────────────────────────┬─────────────────────────────┘
                            │ Calls Methods
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   Data / Repository                     │
│    (Dio HTTP Client / Experience Model / Mock Fallback) │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Directory Structure & File Hygiene

All files follow the dot-separated naming convention (`name.type.dart`) and strict modularity rules (UI files stay under ~200 lines):

- `lib/core/constants/app.colors.dart`: Contains color palette constants matching 8club's dark aesthetics.
- `lib/core/constants/app.text.styles.dart`: Maps Space Grotesk typography scale tokens (`H1`, `H2`, `H3`, `B1`, `B2`, `S1`, `S2`).
- `lib/core/network/dio.client.dart`: Dio HTTP client configuration with base URL, timeouts, and headers.
- `lib/core/theme/app.theme.dart`: Centralized `ThemeData.dark()` configuration.
- `lib/features/host.onboarding/data/models/experience.model.dart`: Data model class for experiences with JSON serialization annotations.
- `lib/features/host.onboarding/data/repositories/experience.repository.dart`: Fetches API data via Dio, with automatic fallback to mock data on network errors.
- `lib/features/host.onboarding/presentation/providers/experiences.provider.dart`: AsyncNotifier provider wrapping experience fetching.
- `lib/features/host.onboarding/presentation/viewmodels/experience.selection.viewmodel.dart`: Manages selected stamp IDs and custom description text for Q1.
- `lib/features/host.onboarding/presentation/viewmodels/host.motivation.viewmodel.dart`: Manages motivation text, audio recording lifecycle, amplitude streaming, audio playback, and video recording for Q2.
- `lib/features/host.onboarding/presentation/widgets/*`: Modular UI components (stamps, buttons, waveform visualizer, progress bar, audio/video player bars).
- `lib/features/host.onboarding/presentation/pages/*`: High-level page containers orchestrating widgets.

---

## 3. External Dependencies & Purpose

| Dependency | Version | Role & Reason Chosen |
| :--- | :--- | :--- |
| `flutter_riverpod` & `riverpod_annotation` | `^2.5.1` / `^2.3.5` | Reactive state management, dependency injection, and type-safe code generation. |
| `dio` | `^5.7.0` | Feature-rich HTTP client with interceptor support, timeouts, and clean error handling. |
| `json_annotation` & `json_serializable` | `^4.9.0` / `^6.8.0` | Strongly-typed JSON parsing and serialization generation. |
| `record` | `^5.1.0` | High-quality cross-platform audio recording with real-time amplitude streams. |
| `just_audio` | `^0.9.40` | Precise audio playback engine for playing recorded voice responses. |
| `image_picker` | `^1.1.2` | Native camera interface for video recording. |
| `cached_network_image` | `^3.4.1` | Efficient image caching and loading placeholder support for stamp icons. |
| `google_fonts` | `^6.2.1` | Dynamic runtime loading for the Space Grotesk typeface. |
| `shimmer` | `^3.0.0` | Elegant shimmer loading animations for AsyncValue states. |

---

## 4. Detailed Component & State Breakdown

### A. Experience Selection (Question 01)
- **ViewModel**: `ExperienceSelectionViewModel` holds `ExperienceSelectionState` (`selectedIds: Set<int>`, `description: String`).
- **Interaction**: Tapping stamp chips toggles ID membership in `selectedIds`. The "Next" button activates dynamically when either at least 1 stamp is selected or custom text is entered (`canProceed`).
- **Rendering**: `ExperienceStampWidget` uses `ContinuousRectangleBorder` with conditional borders (`accentPurple`) and subtle glow shadows when selected.

### B. Host Motivation & Media Integration (Question 02)
- **ViewModel**: `HostMotivationViewModel` holds `HostMotivationState` supporting 3 audio phases: `idle`, `recording`, and `recorded`, alongside video path state.
- **Audio Recording**: Starts `AudioRecorder` and listens to `onAmplitudeChanged` stream. `_normalizeDbfs` converts raw dBFS values into a `[0.08, 1.0]` factor fed into `WaveformVisualizerWidget`.
- **Waveform Visualization**: `WaveformVisualizerWidget` renders animated vertical bars (`AnimatedContainer`) responding to live microphone input.
- **Audio Playback**: Uses `just_audio` to play saved M4A files with toggle state and completion listener.
- **Video Recording**: Picks video using `image_picker` camera source.

---

## 5. Design System Implementation

- **Continuous Rectangles**: All card containers, buttons, stamp items, and player bars use `ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: ...))`. Standard `BorderRadius` creates harsh curvature transitions, whereas continuous curvature matches iOS squircle geometry.
- **Typography Scale**: Built around Space Grotesk with exact line height ratios (`height / fontSize`) and letter spacing factors calculated directly from Figma specifications.
