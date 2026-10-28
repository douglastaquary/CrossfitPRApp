import Testing
@testable import Application
import Domain
import Coaching

@Suite("CoachingClient")
@MainActor
struct CoachingClientTests {
    @Test("PRO usa cache na segunda chamada")
    func cacheHitOnSecondRefresh() async {
        let client = CoachingClient()
        let records = [
            PersonalRecord(prName: "Back Squat", recordDate: Date(), poundValue: 225, group: .barbell),
        ]

        await client.refreshCoaching(records: records, engineInsights: [], tier: .pro, force: true)
        let first = client.latestInsight
        #expect(first?.cacheHit == false)

        await client.refreshCoaching(records: records, engineInsights: [], tier: .pro, force: false)
        #expect(client.latestInsight?.cacheHit == true)
    }

    @Test("Free não gera insight")
    func freeTierSkipsLLM() async {
        let client = CoachingClient()
        await client.refreshCoaching(
            records: [PersonalRecord(prName: "Snatch", recordDate: Date(), poundValue: 135, group: .barbell)],
            engineInsights: [],
            tier: .free
        )
        #expect(client.latestInsight == nil)
    }
}
