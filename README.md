# Lux iOS

Purpose-built voice communication app for talking with an AI agent.

## Overview

Lux iOS is a minimal, focused app for voice-first interaction with the Lux AI agent. The design
priority is low friction: tap, speak, listen.

## Stack

| Layer | Technology |
|---|---|
| Speech-to-Text | [WhisperKit](https://github.com/argmaxinc/WhisperKit) — on-device, Core ML, Neural Engine |
| Text-to-Speech | AVSpeechSynthesizer with enhanced voices |
| Offline Queue | [GRDB](https://github.com/groue/GRDB.swift) + NWPathMonitor + URLSession background config |
| UI | SwiftUI |

## Architecture

### v1 — Tap to Talk
Tap a mic button to begin recording. WhisperKit transcribes on-device. Transcription is POSTed to
the agent-memory backend endpoint (`/message`). Response is read aloud via AVSpeechSynthesizer.
Messages are queued locally via GRDB so they survive offline periods and are flushed when
connectivity returns.

### v2 — ESP32-S3 BLE Wake Word
An ESP32-S3 microcontroller running WakeNet listens for a wake word and triggers the app via BLE.
This sidesteps Apple's background audio restrictions while enabling hands-free activation.

## Requirements

- **Minimum iOS:** 17.0
- **Minimum device:** iPhone XS
- **Audience:** Initially just for Karl (not App Store)

## Status

Early scaffold. Xcode project creation is the next step — `ios/LuxApp.xcodeproj/` is not yet
present. Swift source stubs are in `ios/LuxApp/`.

## Project Structure

```
ios/
  LuxApp/
    LuxApp.swift          — SwiftUI @main entry point
    ContentView.swift     — Tap-to-talk placeholder UI
    AudioManager.swift    — WhisperKit integration (stub)
    MessageQueue.swift    — GRDB offline queue (stub)
    NetworkClient.swift   — HTTP endpoint client (stub)
docs/
  architecture.md         — Architecture decisions and rationale
```

## Next Steps

1. Create `ios/LuxApp.xcodeproj` in Xcode, targeting iOS 17, iPhone
2. Add WhisperKit and GRDB via Swift Package Manager
3. Implement `AudioManager` — recording + WhisperKit transcription
4. Implement `NetworkClient` — POST to agent-memory `/message`
5. Implement `MessageQueue` — GRDB schema + NWPathMonitor flush
6. Wire up `ContentView` end-to-end
