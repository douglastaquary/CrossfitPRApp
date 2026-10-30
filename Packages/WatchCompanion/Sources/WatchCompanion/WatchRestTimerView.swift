import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Timer de descanso CPR-009 Design — ring + timer dominante; evento `rest` ao concluir.
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

    private var progress: Double {
        guard totalDurationSec > 0 else { return 0 }
        return Double(totalDurationSec - remainingSec) / Double(totalDurationSec)
    }

    public var body: some View {
        VStack(spacing: 8) {
            Text(WatchL10n.restLabel)
                .font(WatchDesign.sectionLabel)
                .foregroundStyle(WatchDesign.secondaryLabel)

            ZStack {
                Circle()
                    .stroke(WatchDesign.brand.opacity(0.22), lineWidth: WatchDesign.ringLineWidth)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        WatchDesign.brand,
                        style: StrokeStyle(lineWidth: WatchDesign.ringLineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.25), value: progress)
                Text(formattedTime(remainingSec))
                    .font(WatchDesign.timerFont)
                    .monospacedDigit()
                    .accessibilityIdentifier("watch.rest.timer")
            }
            .frame(width: WatchDesign.restRingSize, height: WatchDesign.restRingSize)

            Text(WatchL10n.restMotivation)
                .font(WatchDesign.micro)
                .foregroundStyle(WatchDesign.secondaryLabel)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Button(isRunning ? WatchL10n.restPause : WatchL10n.restStart) {
                toggleTimer()
            }
            .tint(WatchDesign.brand)
            .accessibilityIdentifier("watch.rest.toggle")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 4)
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
