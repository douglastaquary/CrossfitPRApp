import Foundation
import Testing
@testable import Coaching
import Domain

@Suite("OpenAI Chat Completions coach")
struct OpenAIChatCompletionsCoachClientTests {
    @Test("Parse resposta Chat Completions")
    func parsesCompletionJSON() async throws {
        let contentObject: [String: Any] = [
            "workoutSuggestion": "AMRAP 10",
            "focusLifts": ["Deadlift"],
            "repScheme": "5x3",
            "rationale": "Foco força.",
        ]
        let contentData = try JSONSerialization.data(withJSONObject: contentObject)
        let contentString = String(data: contentData, encoding: .utf8)!
        let envelope: [String: Any] = [
            "choices": [
                ["message": ["content": contentString]],
            ],
        ]
        let responseBody = try JSONSerialization.data(withJSONObject: envelope)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        StubURLProtocol.handler = { _ in
            (
                responseBody,
                HTTPURLResponse(
                    url: CoachingOpenAISettings.defaultChatCompletionsURL,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        }

        let settings = CoachingOpenAISettings(apiKey: "test-key")
        let client = OpenAIChatCompletionsCoachClient(
            settings: settings,
            session: URLSession(configuration: config),
            allowsNetwork: true
        )

        let snapshot = CoachingContextSnapshot(
            windowDays: 90,
            contextHash: "h",
            movements: [],
            stalled: [],
            rising: [],
            engineSignals: CoachingSignals()
        )

        let insight = try await client.generate(snapshot: snapshot, tier: .pro)
        #expect(insight.runtime == .cloud)
        #expect(insight.workoutSuggestion == "AMRAP 10")
    }
}

private final class StubURLProtocol: URLProtocol {
    static var handler: ((URLRequest) -> (Data, URLResponse))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        let (data, response) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
