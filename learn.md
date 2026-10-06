# 8club Host Onboarding App — Learning Guide Index

Welcome! This comprehensive learning guide breaks down everything built in the project into 7 modular lessons located in the `learn/` folder (excluded from Git).

---

## Learning Modules

1. **[Module 01: Flutter Core Concepts & Building Blocks](learn/01_flutter_fundamentals.md)**
   - Flutter rendering engine, Widget tree, `StatelessWidget` vs `StatefulWidget` vs `ConsumerWidget`.
   - `CustomPainter` & path drawing for hand-drawn squiggly lines.
   - `AnimatedScale` & `TweenAnimationBuilder` microinteractions.

2. **[Module 02: Bifrost Architecture & Riverpod State Management](learn/02_bifrost_architecture_and_riverpod.md)**
   - Bifrost clean separation rules (Dumb renderers, ViewModels, Repositories).
   - Riverpod `StateNotifierProvider`, `FutureProvider`, and `AsyncValue.when`.
   - State immutability & `copyWith` patterns.

3. **[Module 03: Design System, Continuous Geometry & Reusable Tokens](learn/03_design_system_and_tokens.md)**
   - `ContinuousRectangleBorder` superellipse curvature vs standard rounded corners.
   - Space Grotesk typography scale mapping (`H1` through `S2`).
   - Centralized `AppGradients` token system.

4. **[Module 04: Networking, Data Models & External Packages](learn/04_networking_and_data_layer.md)**
   - Dio HTTP client configuration & GET `/v1/experiences` integration.
   - External package breakdown (`record`, `just_audio`, `image_picker`, `video_player`, `flutter_svg`).
   - Resilient offline mock fallback mechanism.

5. **[Module 05: Audio & Video Recording, Amplitude Waves & Paginated Carousel](learn/05_media_audio_video_pipeline.md)**
   - Microphone audio recording & amplitude streaming (`dBFS` normalization).
   - Audio playback using `just_audio`.
   - Camera video recording & video frame snapshot renderer (`video_player`).
   - 1 Audio & 1 Video limit + disabled recording button rules.
   - Paginated media carousel widget with auto-scrolling page controller.

6. **[Module 06: Step-by-Step Codebase Walkthrough](learn/06_step_by_step_code_walkthrough.md)**
   - Guided tour connecting all files across application flows.

7. **[Module 07: Interviewer Q&A Master Preparation Guide](learn/07_interviewer_qa_prep.md)**
   - 15 technical interview questions & detailed answers covering architecture, state management, media pipeline, design system, and testing.
