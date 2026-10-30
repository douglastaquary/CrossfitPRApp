import Foundation

/// Cenários de seed para UITest / Previews — CPR-011.
public enum DemoDataScenario: String, Sendable, CaseIterable {
    case empty
    case freeTeaser
    case proRich
    case eliteRich
    case watchLinked
}
