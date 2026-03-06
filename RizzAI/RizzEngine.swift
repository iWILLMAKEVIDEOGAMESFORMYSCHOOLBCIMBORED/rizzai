import Foundation

class RizzEngine {
    static let shared = RizzEngine()
    private init() {}

    private var apiKey: String {
        UserDefaults.standard.string(forKey: "openAIKey") ?? ""
    }

    private var rizzStyle: RizzStyle {
        let raw = UserDefaults(suiteName: "group.com.rizzai.shared")?.string(forKey: "rizzStyle")
            ?? UserDefaults.standard.string(forKey: "rizzStyle")
            ?? RizzStyle.smooth.rawValue
        return RizzStyle(rawValue: raw) ?? .smooth
    }

    // MARK: - Generate lines via OpenAI
    func generateLines(category: RizzCategory, context: String? = nil) async -> [String] {
        guard !apiKey.isEmpty else {
            // Fall back to built-in examples
            return Array(category.examples.shuffled().prefix(5))
        }

        let contextNote = context.map { " Context: \($0)." } ?? ""
        let prompt = """
        Generate 5 unique, creative \(category.title.lowercased()) lines for a dating/texting scenario.\(contextNote)
        Style: \(rizzStyle.title) - \(rizzStyle.description)
        Return ONLY the 5 lines, one per line, no numbering, no quotes, no extra text.
        """

        do {
            let result = try await callOpenAI(systemPrompt: rizzStyle.systemPrompt, userPrompt: prompt)
            let lines = result.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            return Array(lines.prefix(5))
        } catch {
            return Array(category.examples.shuffled().prefix(5))
        }
    }

    // MARK: - Smart reply to a message
    func generateReply(to message: String, context: String? = nil) async -> [String] {
        guard !apiKey.isEmpty else {
            return RizzCategory.responses.examples.shuffled().map { $0 }
        }

        let contextNote = context.map { " Additional context: \($0)." } ?? ""
        let prompt = """
        Someone sent this message: "\(message)"\(contextNote)
        Generate 3 witty, charming replies in the \(rizzStyle.title) style.
        Return ONLY the 3 replies, one per line, no numbering or quotes.
        """

        do {
            let result = try await callOpenAI(systemPrompt: rizzStyle.systemPrompt, userPrompt: prompt)
            let lines = result.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            return Array(lines.prefix(3))
        } catch {
            return Array(RizzCategory.responses.examples.shuffled().prefix(3))
        }
    }

    // MARK: - OpenAI API Call
    private func callOpenAI(systemPrompt: String, userPrompt: String) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw RizzError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "max_tokens": 500,
            "temperature": 0.9
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RizzError.apiError
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let choices = json?["choices"] as? [[String: Any]]
        let message = choices?.first?["message"] as? [String: Any]
        let content = message?["content"] as? String

        return content ?? ""
    }
}

enum RizzError: Error {
    case invalidURL
    case apiError
    case parseError
}
