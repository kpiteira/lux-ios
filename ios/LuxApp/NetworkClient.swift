import Foundation

/// HTTP client for communicating with the agent-memory backend.
///
/// Not implemented. Placeholder for v1 development.
///
/// Intended responsibilities:
/// - POST transcribed text to `/message` on the agent-memory server
/// - Handle response — return agent reply text to caller
/// - Use URLSession background configuration so in-flight requests survive app suspension
///
/// The backend endpoint is thin: the iOS app posts a message and the server
/// routes it to the agent inbox. The app does not interact with agent internals.
final class NetworkClient {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Placeholder API

    /// POST a message to the agent-memory backend.
    /// Returns the agent's reply text on success.
    func send(text: String) async throws -> String {
        // TODO: build URLRequest to POST /message
        // TODO: encode body as JSON { "text": text }
        // TODO: execute with URLSession (background config)
        // TODO: decode response and return reply text
        throw NetworkClientError.notImplemented
    }

    // MARK: - Errors

    enum NetworkClientError: Error {
        case notImplemented
        case requestFailed(Int, String)
        case decodingFailed(String)
    }
}
