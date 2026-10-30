import SwiftUI

/// Tip compacta legada — Sessão usa `WatchWODTimerView` (CPR-016).
@available(*, deprecated, message: "Use WatchWODTimerView")
public struct WatchSessionTipView: View {
    public init() {}

    public var body: some View {
        WatchWODTimerView()
    }
}
