import Foundation

/// Persistent offline queue for outbound messages, backed by GRDB (SQLite).
///
/// Not implemented. Placeholder for v1 development.
///
/// Intended responsibilities:
/// - Write transcribed messages to local SQLite via GRDB immediately on capture
/// - Monitor network connectivity via NWPathMonitor
/// - Flush queued messages to the backend when connectivity is available
/// - Delete rows from the queue on confirmed delivery (2xx response)
/// - Retry on failure — rows remain in the queue until delivered
///
/// Dependencies (to be added via SPM):
///   groue/GRDB.swift
final class MessageQueue {

    // MARK: - Placeholder schema

    struct QueuedMessage {
        let id: Int64?
        let text: String
        let createdAt: Date
        var deliveredAt: Date?
    }

    // MARK: - Placeholder API

    /// Persist a message locally. Returns immediately; delivery is asynchronous.
    func enqueue(_ text: String) throws {
        // TODO: open GRDB connection
        // TODO: insert QueuedMessage row
        throw MessageQueueError.notImplemented
    }

    /// Attempt to deliver all pending messages to the backend.
    /// Called by NWPathMonitor on connectivity change and on app foreground.
    func flush() async throws {
        // TODO: read undelivered rows from GRDB
        // TODO: call NetworkClient.send for each
        // TODO: mark delivered on success
        throw MessageQueueError.notImplemented
    }

    // MARK: - Errors

    enum MessageQueueError: Error {
        case notImplemented
        case databaseError(String)
    }
}
