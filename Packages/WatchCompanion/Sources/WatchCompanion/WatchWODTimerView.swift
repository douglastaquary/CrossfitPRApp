import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Modos de timer WOD no pulso (CPR-016) — sem LLM.
public enum WatchWODMode: String, CaseIterable, Identifiable {
    case amrap
    case emom
    case forTime

    public var id: String { rawValue }

    var labelKey: String {
        switch self {
        case .amrap: return "watch.wod.amrap"
        case .emom: return "watch.wod.emom"
        case .forTime: return "watch.wod.forTime"
        }
    }
}

/// Timer AMRAP / EMOM / For Time + tip compacta (substitui tip-only da Sessão).
public struct WatchWODTimerView: View {
    @State private var mode: WatchWODMode = .amrap
    @State private var elapsedSec = 0
    @State private var emomRemaining = 60
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?

    private let amrapCapSec = 12 * 60

    public init() {}

    public var body: some View {
        VStack(spacing: 6) {
            Picker("", selection: $mode) {
                ForEach(WatchWODMode.allCases) { m in
                    Text(WatchL10n.tr(m.labelKey)).tag(m)
                }
            }
            .labelsHidden()
            .font(.caption2)
            .disabled(isRunning)

            Text(displayTime)
                .font(WatchDesign.timerFont)
                .monospacedDigit()
                .accessibilityIdentifier("watch.wod.timer")

            Text(WatchL10n.sessionTip)
                .font(WatchDesign.micro)
                .foregroundStyle(WatchDesign.secondaryLabel)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            HStack(spacing: 8) {
                Button(isRunning ? WatchL10n.restPause : WatchL10n.restStart) {
                    toggle()
                }
                .tint(WatchDesign.brand)
                .accessibilityIdentifier("watch.wod.toggle")

                Button(WatchL10n.wodReset) {
                    reset()
                }
                .font(.caption2)
                .accessibilityIdentifier("watch.wod.reset")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 4)
        .accessibilityIdentifier("watch.poc.session")
        .onDisappear { stop() }
        .onChange(of: mode) { _ in
            reset()
        }
    }

    private var displayTime: String {
        switch mode {
        case .amrap, .forTime:
            return formattedTime(elapsedSec)
        case .emom:
            return formattedTime(emomRemaining)
        }
    }

    private func toggle() {
        if isRunning { stop() } else { start() }
    }

    private func start() {
        isRunning = true
        timerTask?.cancel()
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                tick()
            }
        }
    }

    private func stop() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    private func reset() {
        stop()
        elapsedSec = 0
        emomRemaining = 60
    }

    private func tick() {
        switch mode {
        case .amrap:
            elapsedSec += 1
            if elapsedSec >= amrapCapSec {
                finish(phase: "amrap")
            }
        case .forTime:
            elapsedSec += 1
        case .emom:
            emomRemaining -= 1
            if emomRemaining <= 0 {
                #if os(watchOS)
                WKInterfaceDevice.current().play(.click)
                #endif
                elapsedSec += 60
                emomRemaining = 60
                WatchEventSink.send(
                    WatchEventPayload(phase: "emom_round", durationSec: elapsedSec)
                )
            }
        }
    }

    private func finish(phase: String) {
        stop()
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #endif
        WatchEventSink.send(
            WatchEventPayload(phase: phase, durationSec: elapsedSec)
        )
    }

    private func formattedTime(_ totalSec: Int) -> String {
        let m = totalSec / 60
        let s = totalSec % 60
        return String(format: "%d:%02d", m, s)
    }
}
