import SwiftUI

/// Snapshot de % load no pulso (CPR-016) — applicationContext ou fixture.
public struct WatchLoadLift: Identifiable, Sendable, Equatable, Hashable {
    public var id: String { name }
    public var name: String
    public var oneRM: Double
    public var unit: String

    public init(name: String, oneRM: Double, unit: String = "kg") {
        self.name = name
        self.oneRM = oneRM
        self.unit = unit
    }

    func workingWeight(percent: Int) -> Int {
        Int((oneRM * Double(percent) / 100.0).rounded())
    }

    func loadChip(percent: Int) -> String {
        "\(percent)% · \(workingWeight(percent: percent)) \(unit)"
    }
}

public enum WatchLoadContext {
    /// Fixture para homologação / sim sem WC.
    public static let fixture: [WatchLoadLift] = [
        WatchLoadLift(name: "Back Squat", oneRM: 140, unit: "kg"),
        WatchLoadLift(name: "Clean", oneRM: 100, unit: "kg"),
        WatchLoadLift(name: "Deadlift", oneRM: 180, unit: "kg"),
    ]

    public static let percents = [70, 80, 90]

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

/// % de 1RM no pulso — lista + detalhe por PR (CPR-016).
public struct WatchPercentLoadView: View {
    @State private var lifts: [WatchLoadLift] = WatchLoadContext.fixture

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(WatchL10n.loadTitle)
                        .font(WatchDesign.sectionLabel)
                        .foregroundStyle(WatchDesign.secondaryLabel)

                    ForEach(lifts) { lift in
                        NavigationLink(value: lift) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(lift.name) · \(Int(lift.oneRM.rounded())) \(lift.unit)")
                                    .font(.caption.weight(.semibold))
                                    .lineLimit(1)
                                    .foregroundStyle(.primary)
                                HStack(spacing: 6) {
                                    ForEach(WatchLoadContext.percents, id: \.self) { pct in
                                        Text(lift.loadChip(percent: pct))
                                            .font(.caption2.monospacedDigit())
                                            .foregroundStyle(WatchDesign.brand)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("watch.load.row.\(lift.id)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
            }
            .navigationDestination(for: WatchLoadLift.self) { lift in
                WatchPercentLoadDetailView(lift: lift)
            }
        }
        .accessibilityIdentifier("watch.poc.load")
        .onAppear {
            lifts = WatchLoadContext.parse(applicationContext: WatchLoadContextStore.latest)
        }
    }
}

/// Detalhe de % load para um PR — pesos de trabalho a partir do 1RM.
struct WatchPercentLoadDetailView: View {
    let lift: WatchLoadLift

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(lift.name)
                    .font(.headline)
                    .accessibilityIdentifier("watch.load.detail.title")

                Text("\(WatchL10n.loadOneRM) · \(Int(lift.oneRM.rounded())) \(lift.unit)")
                    .font(WatchDesign.sectionLabel)
                    .foregroundStyle(WatchDesign.secondaryLabel)
                    .accessibilityIdentifier("watch.load.detail.oneRM")

                Text(WatchL10n.loadDetailHint)
                    .font(WatchDesign.micro)
                    .foregroundStyle(WatchDesign.secondaryLabel)
                    .fixedSize(horizontal: false, vertical: true)

                ForEach(WatchLoadContext.percents, id: \.self) { pct in
                    HStack {
                        Text("\(pct)%")
                            .font(.body.weight(.semibold).monospacedDigit())
                        Spacer()
                        Text("\(lift.workingWeight(percent: pct)) \(lift.unit)")
                            .font(.body.monospacedDigit())
                            .foregroundStyle(WatchDesign.brand)
                    }
                    .accessibilityIdentifier("watch.load.detail.pct.\(pct)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .accessibilityIdentifier("watch.load.detail")
    }
}

/// Último applicationContext recebido no Watch (preenchido pelo target watchOS).
public enum WatchLoadContextStore {
    public static var latest: [String: Any]?
}
