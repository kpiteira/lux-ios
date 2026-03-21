import Foundation

/// Manages audio recording and on-device speech-to-text transcription via WhisperKit.
///
/// Not implemented. Placeholder for v1 development.
///
/// Intended responsibilities:
/// - Configure AVAudioSession for recording
/// - Start / stop audio capture
/// - Pass recorded audio to WhisperKit for transcription
/// - Deliver transcribed text to the caller via async/callback
///
/// Dependencies (to be added via SPM):
///   argmaxinc/WhisperKit
@MainActor
final class AudioManager: ObservableObject {

    @Published var isRecording = false
    @Published var transcribedText: String?

    // MARK: - Placeholder API

    func startRecording() {
        // TODO: configure AVAudioSession
        // TODO: begin audio capture
        isRecording = true
    }

    func stopRecording() async throws -> String {
        // TODO: stop capture
        // TODO: run WhisperKit transcription on recorded buffer
        // TODO: return transcribed string
        isRecording = false
        throw AudioManagerError.notImplemented
    }

    // MARK: - Errors

    enum AudioManagerError: Error {
        case notImplemented
        case recordingFailed(String)
        case transcriptionFailed(String)
    }
}
