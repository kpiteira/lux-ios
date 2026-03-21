# Lux iOS — Architecture

## Goals

- Voice-first, low-friction interaction with the Lux AI agent
- Works offline: messages queue locally and flush when connectivity returns
- No App Store dependency: sideloaded for personal use
- Avoid Apple background audio restrictions in v1 via tap-to-talk

---

## Speech-to-Text: WhisperKit

**Package:** [argmaxinc/WhisperKit](https://github.com/argmaxinc/WhisperKit)

WhisperKit runs OpenAI Whisper entirely on-device using Core ML and the Apple Neural Engine.

**Why WhisperKit over alternatives:**
- No network round-trip for transcription — works offline
- Swift-native API, no bridging overhead
- Neural Engine acceleration on A12+ (iPhone XS and later)
- iOS 17+ deployment target aligns with ANE capabilities
- Open source, auditable, no third-party data retention

**Rejected alternatives:**
- Apple Speech framework (SFSpeechRecognizer): requires network for best accuracy, limited
  language model control
- Cloud STT (Deepgram, Whisper API): adds latency, requires connectivity, sends audio offsite

---

## Text-to-Speech: AVSpeechSynthesizer

**Framework:** AVFoundation — `AVSpeechSynthesizer` + enhanced voices (iOS 16+)

v1 uses system TTS. Enhanced voices (downloadable, on-device) are available since iOS 16 and
produce noticeably more natural output than the compact voices.

**Why not ElevenLabs or similar:**
- Adds network dependency and latency
- Enhanced system voices are sufficient for v1
- Can be revisited in v2 if quality is a blocker

---

## Offline Queue: GRDB + NWPathMonitor

**Packages:**
- [groue/GRDB.swift](https://github.com/groue/GRDB.swift) — SQLite wrapper, used for local
  message persistence
- `NWPathMonitor` (Network framework) — monitors connectivity
- `URLSession` background configuration — for in-flight requests that survive app suspension

**Pattern:**
1. User speaks — transcription is written to local GRDB queue immediately
2. `NWPathMonitor` watches for connectivity
3. When online, a flush routine reads the queue and POSTs to the backend
4. On confirmed delivery (2xx), the row is deleted from the queue
5. On failure, the row stays and will be retried on next flush

This means the app is never blocked by connectivity. Messages are never lost.

---

## Backend Integration

**Endpoint:** thin HTTP endpoint in the agent-memory server

- App POSTs to `/message` with transcribed text (and optional metadata)
- Server routes the message to the agent's inbox
- Agent processes and returns a response (sync or async TBD)
- Response text is passed to AVSpeechSynthesizer

The backend is deliberately thin — the iOS app does not need to know about agent internals.

---

## Wake Word

### v1 — Tap to Talk

Simple mic button in the UI. No background audio session required. Tap starts recording, tap
again (or silence detection) stops and triggers transcription.

**Why start here:** avoids all Apple background audio entanglement. Fast to implement, covers
the primary use case for a personal device in hand.

### v2 — ESP32-S3 + WakeNet + BLE

An ESP32-S3 microcontroller (with built-in microphone support) runs Espressif's WakeNet model
locally. When the wake word is detected, the ESP32 sends a BLE notification to the iPhone.
The iOS app listens for this BLE trigger (CoreBluetooth, background BLE scanning is permitted)
and starts the recording session.

**Why this approach:**
- Apple does not permit arbitrary background audio processing for wake word detection on iOS
  without `voip` or `audio` background modes, both of which are App Store gatekept and
  inappropriate here
- A dedicated microcontroller is cheaper and more power-efficient for always-on keyword spotting
- BLE peripheral triggers are explicitly supported as a background wake mechanism
- ESP32-S3 is inexpensive (~$5), widely available, runs WakeNet natively

---

## Minimum Requirements

| Requirement | Value | Rationale |
|---|---|---|
| iOS | 17.0 | WhisperKit Neural Engine support, SwiftUI maturity |
| Device | iPhone XS | A12 Bionic — first chip with dedicated Neural Engine |

---

## What This Is Not

- Not an App Store app (no reviewer constraints)
- Not a multi-user product (personal use, Karl only in v1)
- Not a real-time streaming app (push-to-talk is acceptable latency)
