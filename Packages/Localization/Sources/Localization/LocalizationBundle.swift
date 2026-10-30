import Foundation

/// Escolhe a tabela de strings do pacote.
///
/// UI tests passam `-AppleLanguages (en)` ou `(pt-BR)`. No simulador do CI esse
/// argumento não troca o idioma de `Bundle.module` — o fallback do pacote é
/// pt-BR — e a string em inglês saía em português. Com o argumento presente,
/// a tabela do `.lproj` pedido é lida direto.
enum LocalizationBundle {
    private static let overrideTable: [String: String]? = {
        guard let code = languageCode(from: ProcessInfo.processInfo.arguments) else { return nil }
        return table(languageCode: code)
    }()

    static func string(for key: String) -> String {
        if let overrideTable, let value = overrideTable[key], !value.isEmpty {
            return value
        }
        return NSLocalizedString(key, bundle: .module, comment: "")
    }

    static func languageCode(from arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: "-AppleLanguages"),
              index + 1 < arguments.count else {
            return nil
        }
        return languageCode(fromAppleLanguagesArgument: arguments[index + 1])
    }

    static func languageCode(fromAppleLanguagesArgument raw: String) -> String? {
        let trimmed = raw
            .trimmingCharacters(in: CharacterSet(charactersIn: "()\""))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.split(separator: ",").first else { return nil }
        let code = first.trimmingCharacters(in: .whitespacesAndNewlines)
        return code.isEmpty ? nil : String(code)
    }

    static func table(languageCode: String) -> [String: String]? {
        let normalized = languageCode.replacingOccurrences(of: "_", with: "-")
        var candidates = [normalized]
        if let prefix = normalized.split(separator: "-").first {
            let language = String(prefix)
            if language != normalized {
                candidates.append(language)
            }
        }
        for candidate in candidates {
            guard let path = Bundle.module.path(
                forResource: "Localizable",
                ofType: "strings",
                inDirectory: nil,
                forLocalization: candidate
            ) else { continue }
            guard let raw = NSDictionary(contentsOfFile: path) else { continue }
            var table: [String: String] = [:]
            for case let (key as String, value as String) in raw {
                table[key] = value
            }
            if !table.isEmpty {
                return table
            }
        }
        return nil
    }
}
