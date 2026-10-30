import SwiftUI

/// Snapshot de % load no pulso (CPR-016) — applicationContext ou fixture.
public struct WatchLoadLift: Identifiable, Sendable, Equatable {
    public var id: String { name }
    public var name: String
    public var oneRM: Double
    public var unit: String

    public init(name: String, oneRM: Double, unit: String = "kg") {
        self.name = name
        self.oneRM = oneRM
        self.unit = unit
    }
}

public enum WatchLoadContext {
    /// Fixture para homologação / sim sem WC.
    public static let fixture: [WatchLoadLift] = [
        WatchLoadLift(name: "Back Squat", oneRM: 140, unit: "kg"),
        WatchLoadLift(name: "Clean", oneRM: 100, unit: "kg"),
        WatchLoadLift(name: "Deadlift", oneRM: 180, unit: "kg"),
    ]

    public static func parse(applicationContext: [String: Any]?) -> [WatchLoadLift] {
        guard let raw = applicationContext?["lifts"] as? [[String: Any]], !raw.isEmpty else {
            return fixture
        }
        let parsed: [WatchLoadLift] = raw.compactMap { dict in
            guard let name = dict["name"] as? String,
                  let oneRM = dict["oneRM"] as? Double else { return nil }
            let unit = dict["unit"] as? String ?? "kg"
            return WatchLoadLift(name: name, oneRM: oneRM, unit: unit)
        }
        return parsed.isEmpty ? fixture : Array(parsed.prefix(3))
    }
}

/// % de 1RM no pulso — 70 / 80 / 90 para lifts recentes.
public struct WatchPercentLoadView: View {
    private let percents = [70, 80, 90]
    @State private var lifts: [WatchLoadLift] = WatchLoadContext.fixture

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(WatchL10n.loadTitle)
                    .font(WatchDesign.sectionLabel)
                    .foregroundStyle(WatchDesign.secondaryLabel)

                ForEach(lifts) { lift in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(lift.name)
                            .font(.caption.weight(.semibold))
                            .lineLimit(1)
                        HStack(spacing: 6) {
                            ForEach(percents, id: \.self) { pct in
                                let value = lift.oneRM * Double(pct) / 100.0
                                Text("\(pct)% \(Int(value.rounded()))")
                                    .font(.caption2.monospacedDigit())
                                    .foregroundStyle(WatchDesign.brand)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .accessibilityIdentifier("watch.poc.load")
        .onAppear {
            lifts = WatchLoadContext.parse(applicationContext: WatchLoadContextStore.latest)
        }
    }
}

/// Último applicationContext recebido no Watch (preenchido pelo target watchOS).
public enum WatchLoadContextStore {
    public static var latest: [String: Any]?
}
