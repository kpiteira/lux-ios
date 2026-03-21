# ESP32-S3 Wake Word Puck — Hardware Design v0.1

*Researched: 2026-03-21*

---

## Overview

Battery-powered, always-listening desk puck. Runs WakeNet9 locally on ESP32-S3. On wake word detection, sends a 1-byte BLE GATT notification to the lux-ios iPhone app. App wakes even when backgrounded/screen-locked. No cloud round-trip for the trigger.

---

## Key Decisions

### Board: Seeed XIAO ESP32-S3 Sense (~$14)
- 21 × 17.8 mm — smallest ESP32-S3 with PSRAM
- Onboard PDM mic (SPM1423, GPIO 41/42) — eliminates external component
- 8 MB OPI PSRAM — satisfies WakeNet9's 324 KB PSRAM requirement
- USB-C charging built-in — no TP4056 needed
- JST battery pads

### Microphone: Onboard SPM1423 (PDM)
- 61 dB SNR, flat 60 Hz–15 kHz, 0.6 mA
- Works directly with WakeNet9 AFE (I2S driver handles PDM→PCM)
- If needed: ICS-43434 via I2S (GPIO 6/7/8) — 65 dB SNR, not deprecated

### Wake Word: WakeNet9 via ESP-SR
- 16 KB SRAM + 324 KB PSRAM + 4,152 KB flash model partition
- ~30 mA total pipeline load at 240 MHz
- ~3 ms per 32 ms frame (~10% of one core)
- 94–98% detection at 1–3 m
- **"Hey Lux" doesn't exist yet** — use `wn9_heywillow_tts` as phonetic stand-in during dev
- Custom model requires: 100+ recordings → Espressif TTS augmentation → training

### BLE: Custom GATT Service
```
Service UUID:    A1B2C3D4-0000-1000-8000-00805F9B34FB
Characteristic:  A1B2C3D4-0001-1000-8000-00805F9B34FB
  Properties:    NOTIFY
  Payload:       1 byte (0x01=wake, 0x02=low battery)
```
- iOS uses `bluetooth-central` background mode — receives notifications screen-off
- State restoration ensures CBCentralManager survives app suspension
- No audio streaming — just the trigger event

### Power: 400 mAh LiPo (502535, ~$6)
- 35 mA steady draw → ~11 hours
- Fits alongside XIAO in 40mm diameter puck
- Charge nightly via USB-C

### Enclosure: 40mm × 18mm cylinder (3D print, PETG)
- XIAO + LiPo side-by-side
- 2mm mic port on top cap
- USB-C cutout on base

---

## BOM (~$20–22 total)

| Component | Cost |
|-----------|------|
| XIAO ESP32-S3 Sense | $13.99 |
| LiPo 400mAh 502535 | $6 |
| LED + resistors + misc | $1 |
| PETG filament + screws | $1 |

---

## Biggest Open Risks

1. **iOS background BLE reliability** — iOS can defer BLE notifications under battery pressure. Test early with real device.
2. **"Hey Lux" custom model** — Espressif's commercial path is for volume users. Personal training toolchain exists but needs validation.
3. **Close-field mic acoustics** — 94% accuracy measured at 1–3m. Desk distance (30–50cm) with bottom-port mic orientation needs empirical validation.
4. **BLE range through walls** — Test from desk to iPhone in pocket across a room. Enable BLE 5 coded PHY if needed.

---

## Next Steps

1. Order XIAO ESP32-S3 Sense + LiPo
2. Get esp-idf v5.2 + esp-sr running with `wn9_heywillow_tts` stand-in
3. Implement BLE GATT server (NimBLE, not Bluedroid)
4. Wire iOS `bluetooth-central` in lux-ios
5. Test background notification reliability
6. Design enclosure, print in PETG
7. Begin "Hey Lux" custom wake word training
