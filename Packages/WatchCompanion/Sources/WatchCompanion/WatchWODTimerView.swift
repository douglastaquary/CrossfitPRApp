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

/// Timer AMRAP / EMOM / For Time + rest próprio da Sessão (duração independente da tab Descanso).
public struct WatchWODTimerView: View {
    @AppStorage(WatchRestDuration.wodTabKey) private var restDurationSec = WatchRestDuration.defaultSec

    @State private var mode: WatchWODMode = .amrap
    @State private var elapsedSec = 0
    @State private var emomRemaining = 60
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?

    @State private var restRemainingSec = WatchRestDuration.defaultSec
    @State private var isRestRunning = false
    @State private var restTask: Task<Void, Never>?

    private let amrapCapSec = 12 * 60

    public init() {}

    private var wodRestTotal: Int { WatchRestDuration.clamped(restDurationSec) }

    private var canEditRestDuration: Bool { !isRunning && !isRestRunning }

    public var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Picker("", selection: $mode) {
                    ForEach(WatchWODMode.allCases) { m in
                        Text(WatchL10n.tr(m.labelKey)).tag(m)
                    }
                }
                .labelsHidden()
                .font(.caption2)
                .disabled(isRunning || isRestRunning)

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
                    .disabled(isRestRunning)
                    .accessibilityIdentifier("watch.wod.toggle")

                    Button(WatchL10n.wodReset) {
                        reset()
                    }
                    .font(.caption2)
                    .disabled(isRestRunning)
                    .accessibilityIdentifier("watch.wod.reset")
                }

                Divider().padding(.vertical, 2)

                Text(WatchL10n.wodRestLabel)
                    .font(WatchDesign.sectionLabel)
                    .foregroundStyle(WatchDesign.secondaryLabel)

                Picker(WatchL10n.wodRestDuration, selection: $restDurationSec) {
                    ForEach(WatchRestDuration.presets, id: \.self) { sec in
                        Text(WatchRestDuration.label(seconds: sec)).tag(sec)
                    }
                }
                .labelsHidden()
                .font(.caption2)
                .disabled(!canEditRestDuration)
                .accessibilityIdentifier("watch.wod.rest.duration")

                Text(formattedTime(restRemainingSec))
                    .font(.title3.monospacedDigit().weight(.semibold))
                    .foregroundStyle(WatchDesign.brand)
                    .accessibilityIdentifier("watch.wod.rest.timer")

                Button(isRestRunning ? WatchL10n.restPause : WatchL10n.wodRestStart) {
                    toggleRest()
                }
                .tint(WatchDesign.brand)
                .disabled(isRunning)
                .accessibilityIdentifier("watch.wod.rest.toggle")
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
        }
        .accessibilityIdentifier("watch.poc.session")
        .onAppear { syncRestIfIdle() }
        .onChange(of: restDurationSec) { _ in
            guard !isRestRunning else { return }
            restRemainingSec = wodRestTotal
        }
        .onChange(of: mode) { _ in
            reset()
        }
        .onDisappear {
            stop()
            stopRest()
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

    private func syncRestIfIdle() {
        guard !isRestRunning else { return }
        restRemainingSec = wodRestTotal
    }

    private func toggle() {
        if isRunning { stop() } else { start() }
    }

    private func start() {
        stopRest()
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
        stopRest()
        elapsedSec = 0
        emomRemaining = 60
        restRemainingSec = wodRestTotal
    }

    private func toggleRest() {
        if isRestRunning {
            stopRest()
        } else {
            startRest()
        }
    }

    private func startRest() {
        stop()
        if restRemainingSec <= 0 {
            restRemainingSec = wodRestTotal
        }
        isRestRunning = true
        restTask?.cancel()
        restTask = Task { @MainActor in
            while !Task.isCancelled, restRemainingSec > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                restRemainingSec -= 1
            }
            guard !Task.isCancelled else { return }
            isRestRunning = false
            completeWODRest()
        }
    }

    private func stopRest() {
        isRestRunning = false
        restTask?.cancel()
        restTask = nil
    }

    private func completeWODRest() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #endif
        WatchEventSink.send(
            WatchEventPayload(phase: "wod_rest", durationSec: wodRestTotal)
        )
        restRemainingSec = wodRestTotal
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
        WatchRestDuration.label(seconds: max(0, totalSec))
    }
}
