# Video Walkthrough Script & Director's Guide

This document provides a timed **1 to 2 minute video walkthrough script** for your application demonstration video recording for the 8club submission, complete with exact spoken lines, on-screen actions, and detailed explanatory notes.

---

## Video Setup Recommendations
- **Screen Recorder**: OBS Studio, QuickTime, or Loom.
- **Resolution**: 1080p (portrait mobile emulator or mirror phone screen).
- **Target Duration**: 90 to 120 seconds.

---

## 🎬 Timed Walkthrough Script

### **SECTION 1: Introduction & Architecture Overview (0:00 – 0:20)**

#### 🎥 **On-Screen Action**:
- Open app on emulator/device showing Screen 1 (**Question 01: What kind of hotspots do you want to host?**).
- Point out the top header with the squiggly wave progress bar (`OnboardingProgressBarWidget`) and top gradient container (`AppGradients.topHeaderLight`).
- Show that all experience stamps are initially rendered **straight and monochromatic**.

#### 🎙️ **Spoken Script**:
> "Hi team! Today I'm excited to present my Flutter application for the 8club Host Onboarding assignment.
> The app is built strictly following Bifrost Architecture—using Riverpod for state management, Dio for network repositories, and zero business logic inside UI widgets."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Immediately establishes that you followed the required Bifrost architecture, clean separation of concerns, and Riverpod state management rules.

---

### **SECTION 2: Screen 1 — Experience Stamps & Microinteractions (0:20 – 0:50)**

#### 🎥 **On-Screen Action**:
1. Show that the **Next button is initially disabled** (`#141414` dark surface with muted grey icon).
2. Show that the top back button is disabled on Screen 1.
3. Type text into the text box—point out that text input alone keeps Next disabled until an experience stamp card is selected.
4. Tap on the **Party** stamp card: observe the tactile scale bounce animation (`AnimatedScale`), the colored artwork asset, and the left tilt rotation (`-0.07` radians).
5. Tap on **Brunch**: show multi-selection with right tilt rotation (`+0.07` radians).
6. Scroll the horizontal stamp list: point out the subtle **StampScrollIndicatorWidget** (~1/10th screen width) smoothly tracking scroll progress below the stamps!
7. Point out the top **Squiggly Wave Progress Bar** smoothly animating from `0.0` to `0.5`!
8. Show the **Next button** activating with its glossy dark-to-light whitish gradient background (`AppGradients.buttonEnabled`) and `next.svg` icon.

#### 🎙️ **Spoken Script**:
> "Here on Screen 1, experience stamps are dynamically fetched from the 8club REST endpoint with automatic offline mock fallback.
> All components use continuous rectangular borders (`ContinuousRectangleBorder`) to match 8club's squircle geometry.
> Notice the stamp microinteractions: by default, stamps are straight and monochromatic. Upon selection, they tilt and transform into full color while displaying event titles directly inside the stamp artwork.
> As we scroll, a subtle horizontal scroll indicator tracks our progress.
> The Next button uses a top-to-bottom whitish gradient background and only activates once at least one experience card is selected, smoothly animating our handdrawn squiggly progress line to 50%."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Demonstrates UI/UX fidelity (25%), continuous rectangle styling, Riverpod reactive validation, network API integration (20%), custom scroll indicators, and microinteraction animations.

---

### **SECTION 3: Screen 2 — Text Focus & Media Integration (0:50 – 1:30)**

#### 🎥 **On-Screen Action**:
1. Tap **Next** to navigate to Screen 2 (**Why do you want to host with us?**).
2. Tap into the text box: demonstrate the **focused purple outline border** (`#8B8BE8`) animating around the text container.
3. Tap the **Microphone Icon** on the bottom action bar:
   - Point out the spotlight gradient background on the mic button (`AppGradients.micActiveSpotlight`).
   - Show the live **Audio Recording Bar** appearing above the bottom bar with animated waveform bars reacting to voice input.
4. Tap **Stop** (checkmark button):
   - Show the Audio Recorded player bar with duration counter and play button.
   - Point out that the Microphone action button on the bottom bar is now **disabled** (muted opacity), enforcing the 1 audio clip limit!
5. Tap **Play**: play back the recorded audio through the speaker while showing animated waveform bars inside `AudioPlayerBarWidget`!
6. Tap **Video Camera Icon**: capture a video response.
7. Show the **Paginated Media Carousel**: auto-swipes to Page 1 displaying the Video Snapshot Thumbnail frame (rendered via `VideoPlayerController` at 0.0s) with play icon overlay!
8. Point out the page dot indicators (`● ○`) allowing swiping between Audio Recorded bar and Video Snapshot Thumbnail bar!
9. Point out that the Video Camera action button is now also **disabled** (muted opacity), enforcing the 1 video clip limit!

#### 🎙️ **Spoken Script**:
> "On Screen 2, tapping the text field triggers an animated lilac purple focus border.
> Tapping the mic button starts live audio recording using the `record` package, displaying animated waveform bars driven by real-time microphone amplitude streaming.
> After stopping, `just_audio` lets us play back the recorded clip with animated waveform bars.
> Recording an audio clip disables the mic button until removed.
> Next, recording a video response automatically scrolls our paginated media container to display a real video frame snapshot extracted via `video_player`.
> Both recording buttons are now disabled, and swipable page dots allow smooth navigation between media responses."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Demonstrates Media & Audio integration (15%), amplitude normalization formulas, just_audio playback, video snapshot extraction, 1 audio / 1 video limits, and paginated PageView UI.

---

### **SECTION 4: Cancel Reset & Flow Completion (1:30 – 1:45)**

#### 🎥 **On-Screen Action**:
1. Tap the top-right **Close/Cancel (`X`) Icon Button**: show that it resets text, deletes recorded audio and video files, animates progress back to `0.5`, and disables the Next button!
2. Record an audio clip again to enable Next, then tap **Next**.
3. Show the **Application Submitted** completion page with back-to-start action.

#### 🎙️ **Spoken Script**:
> "Tapping the cancel button at any point resets the current page state, clearing media files and disabling Next until input is re-added.
> Finally, tapping Next completes the host application flow and brings us to the submission screen.
> All code is modular, fully analyzed with zero lints or warnings, and backed by comprehensive unit tests, learning modules, and Git history. Thank you!"

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Confirms code cleanliness (15%), cancel reset state management, zero lint warnings, automated test coverage, and clean Git history.
