import Testing
@testable import Coaching

@Suite("CoachingInsightJSONParser")
struct CoachingInsightJSONParserTests {
    @Test("Parse JSON puro")
    func plainJSON() throws {
        let raw = """
        {"workoutSuggestion":"EMOM 12","focusLifts":["Squat"],"repScheme":"3x5","rationale":"Volume técnico."}
        """
        let payload = try CoachingInsightJSONParser.parse(raw)
        #expect(payload.workoutSuggestion == "EMOM 12")
        #expect(payload.focusLifts == ["Squat"])
    }

    @Test("Extrai JSON de resposta com texto extra")
    func fencedJSON() throws {
        let raw = """
        Here is the plan:
        {"workoutSuggestion":"Skill","focusLifts":[],"repScheme":"—","rationale":"Ok"}
        """
        let payload = try CoachingInsightJSONParser.parse(raw)
        #expect(payload.workoutSuggestion == "Skill")
    }
}
