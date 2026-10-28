import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Timer de descanso CPR-009 — envia evento `rest` ao concluir.
public struct WatchRestTimerView: View {
    private let totalDurationSec: Int

    @State private var remainingSec: Int
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?

    public init(initialDurationSec: Int = 90) {
        let duration = max(1, initialDurationSec)
        totalDurationSec = duration
        _remainingSec = State(initialValue: duration)
    }

    public var body: some View {
        VStack(spacing: 10) {
            Text(WatchL10n.restLabel)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text(formattedTime(remainingSec))
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
                .accessibilityIdentifier("watch.rest.timer")
            Text(WatchL10n.restMotivation)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(isRunning ? WatchL10n.restPause : WatchL10n.restStart) {
                toggleTimer()
            }
            .accessibilityIdentifier("watch.rest.toggle")
        }
        .padding()
        .accessibilityIdentifier("watch.poc.rest")
        .onDisappear { stopTimer() }
    }

    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        isRunning = true
        timerTask?.cancel()
        timerTask = Task { @MainActor in
            while !Task.isCancelled, remainingSec > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                remainingSec -= 1
            }
            guard !Task.isCancelled else { return }
            isRunning = false
            completeRest()
        }
    }

    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    private func completeRest() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #endif
        WatchEventSink.send(
            WatchEventPayload(phase: "rest", durationSec: totalDurationSec)
        )
        remainingSec = totalDurationSec
    }

    private func formattedTime(_ totalSec: Int) -> String {
        let m = totalSec / 60
        let s = totalSec % 60
        return String(format: "%d:%02d", m, s)
    }
}
