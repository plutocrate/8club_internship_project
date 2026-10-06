# Video Walkthrough Script & Director's Guide

This document provides a timed **1 to 2 minute video walkthrough script** for screen recording your application demonstration for the 8club internship submission, complete with exact spoken lines, on-screen actions, and detailed explanatory notes.

---

## Video Setup Recommendations
- **Screen Recorder**: OBS Studio, QuickTime, or Loom.
- **Resolution**: 1080p (portrait mobile emulator or mirror phone screen).
- **Target Duration**: 90 to 120 seconds.

---

## 🎬 Timed Walkthrough Script

### **SECTION 1: Introduction & Architecture Overview (0:00 – 0:20)**

#### 🎥 **On-Screen Action**:
- Open app on emulator/device showing Screen 1 (**Question 01: What kind of experiences do you want to host?**).
- Show the top header with the squiggly progress bar and top dark gradient container.

#### 🎙️ **Spoken Script**:
> "Hi team! Today I'm excited to present my Flutter application for the 8club Host Onboarding assignment.
> The app is built strictly following Bifrost Architecture—using Riverpod for state management, Dio for network repositories, and zero business logic inside UI widgets."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Immediately establishes that you followed the required Bifrost architecture, separation of concerns, and clean state management.

---

### **SECTION 2: Screen 1 — Experience Stamps & Microinteractions (0:20 – 0:50)**

#### 🎥 **On-Screen Action**:
1. Show that the **Next button is initially disabled** with a dark solid surface.
2. Type text in the text box—point out that text alone keeps Next disabled until a stamp card is selected.
3. Tap on the **Party** stamp card: observe the tactile scale bounce animation (`AnimatedScale`), the terracotta red background fill, and the purple glowing continuous rectangle border.
4. Tap on **Brunch**: show multi-selection with teal blue fill.
5. Point out the top **Squiggly Wave Progress Bar** smoothly animating from `0.0` to `0.5`!
6. Show the **Next button** activating with its glossy dark-to-light whitish gradient background (`AppGradients.buttonEnabled`).

#### 🎙️ **Spoken Script**:
> "Here on Screen 1, experience stamps are dynamically fetched from the 8club REST endpoint with automatic offline mock fallback.
> All components use continuous rectangular borders (`ContinuousRectangleBorder`) to match 8club's squircle geometry.
> Notice the microinteraction on stamp selection: smooth scale bounce, signature color palette fills, and purple glowing borders.
> The Next button uses a top-to-bottom whitish gradient background and only activates once at least one experience card is selected, smoothly animating our handdrawn squiggly progress line to 50%."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Demonstrates UI/UX fidelity (25%), continuous rectangle styling, Riverpod reactive validation, network API integration (20%), and custom painter microinteractions.

---

### **SECTION 3: Screen 2 — Text Focus & Audio/Video Media Integration (0:50 – 1:30)**

#### 🎥 **On-Screen Action**:
1. Tap **Next** to navigate to Screen 2 (**Why do you want to host with us?**).
2. Tap into the text box: demonstrate the **focused purple outline border** (`#8B8BE8`) animating around the text container.
3. Tap the **Microphone Icon** on the bottom action bar:
   - Point out the active microphone gradient background on the button.
   - Show the live **Audio Recording Bar** appearing above the bottom bar with animated waveform bars reacting to voice input.
4. Tap **Stop**: show the Audio Recorded player bar with duration counter.
5. Tap **Play**: play back the recorded audio through the speaker.
6. Tap **Video Camera Icon**: capture or pick a video response.
7. Show the **Paginated Media Carousel**: swipe between Page 1 (Audio Player) and Page 2 (Video Snapshot preview with frame thumbnail and play overlay), pointing out the page dot indicators!

#### 🎙️ **Spoken Script**:
> "On Screen 2, tapping the text field triggers an animated lilac purple focus border.
> Tapping the mic button starts live audio recording using the `record` package, displaying animated waveform bars driven by real-time microphone amplitude streaming.
> After stopping, `just_audio` lets us play back the recorded clip.
> We can also record a video response, which displays a thumbnail frame preview.
> When both audio and video are recorded, a paginated media carousel renders above the bottom bar with smooth dot indicators allowing seamless swiping between responses."

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Demonstrates Media & Audio integration (15%), amplitude normalization formulas, just_audio playback, image_picker camera video, and paginated PageView UI.

---

### **SECTION 4: Submission & Flow Completion (1:30 – 1:45)**

#### 🎥 **On-Screen Action**:
1. Tap **Next** on Screen 2.
2. Show the **Application Submitted** completion page with back-to-start action.

#### 🎙️ **Spoken Script**:
> "Finally, tapping Next completes the host application flow and brings us to the confirmation screen.
> All code is modular, fully analyzed with zero lints or warnings, and backed by comprehensive unit tests and Git commit history. Thank you!"

#### 💡 `[BEHIND THE SCENES EXPLANATION]`
> *Why speak this:* Confirms code cleanliness (15%), zero lint warnings, automated test coverage, and clean Git history.
