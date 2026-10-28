import SwiftUI
import Localization

/// Telas POC CPR-009 — compartilhadas com target watchOS futuro; galeria iOS para README.
public struct WatchSessionTipView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.title2)
                .foregroundStyle(AppDesign.Colors.brand)
            Text(Strings.Watch.sessionTitle)
                .font(.headline)
            Text(Strings.Watch.sessionTip)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .accessibilityIdentifier("watch.poc.session")
    }
}

public struct WatchRestTimerView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 10) {
            Text(Strings.Watch.restLabel)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text("1:30")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(Strings.Watch.restMotivation)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .accessibilityIdentifier("watch.poc.rest")
    }
}

public struct WatchBreathingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            Text(Strings.Watch.breathTitle)
                .font(.headline)
            Text(Strings.Watch.breathPattern)
                .font(.title3.monospaced())
            Circle()
                .stroke(AppDesign.Colors.brand.opacity(0.5), lineWidth: 3)
                .frame(width: 72, height: 72)
                .overlay(
                    Text(Strings.Watch.breathInhale)
                        .font(.caption2)
                )
        }
        .padding()
        .accessibilityIdentifier("watch.poc.breath")
    }
}

public struct WatchPOCGalleryView: View {
    @State private var page = 0

    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            Text(Strings.Watch.galleryTitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            Group {
                switch page {
                case 0: watchFrame { WatchSessionTipView() }
                case 1: watchFrame { WatchRestTimerView() }
                default: watchFrame { WatchBreathingView() }
                }
            }
            .frame(maxHeight: 420)
            .animation(.easeInOut(duration: 0.2), value: page)

            Button(Strings.Watch.galleryNext) {
                page = min(page + 1, 2)
            }
            .accessibilityIdentifier("watch.poc.next")
        }
        .padding()
        .accessibilityIdentifier("watch.poc.gallery")
    }

    private func watchFrame<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black.opacity(0.92))
            content()
                .foregroundStyle(.white)
        }
        .frame(width: 180, height: 220)
        .padding(.vertical, 8)
    }
}
