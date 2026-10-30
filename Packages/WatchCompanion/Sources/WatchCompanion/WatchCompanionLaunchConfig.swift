import Foundation

/// Tab inicial para capturas README / automação (`-WatchSnapshotTab` ou `WATCH_SNAPSHOT_TAB`).
enum WatchCompanionLaunchConfig {
    static var initialTab: Int {
        let args = ProcessInfo.processInfo.arguments
        if let idx = args.firstIndex(of: "-WatchSnapshotTab"), idx + 1 < args.count,
           let value = Int(args[idx + 1]), (0 ... 3).contains(value) {
            return value
        }
        if let raw = ProcessInfo.processInfo.environment["WATCH_SNAPSHOT_TAB"],
           let value = Int(raw), (0 ... 3).contains(value) {
            return value
        }
        return 0
    }
}
