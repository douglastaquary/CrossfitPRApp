import Foundation
import Domain

/// Buffer local de eventos recebidos do Apple Watch (WatchConnectivity).
@MainActor
public final class WatchSessionEventStore: ObservableObject {
    public static let shared = WatchSessionEventStore()

    @Published public private(set) var events: [WatchSessionEvent] = []

    private let maxStored = 12

    private init() {}

    public func ingest(watchConnectivityPayload payload: [String: Any]) {
        guard let event = WatchSessionEvent(watchConnectivityPayload: payload) else { return }
        events.append(event)
        if events.count > maxStored {
            events.removeFirst(events.count - maxStored)
        }
    }

    public func recentEvents(limit: Int = 8) -> [WatchSessionEvent] {
        Array(events.suffix(limit))
    }

    public func clear() {
        events = []
    }
}
