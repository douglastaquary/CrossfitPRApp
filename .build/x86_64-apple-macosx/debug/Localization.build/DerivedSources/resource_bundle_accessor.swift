import class Foundation.Bundle

extension Foundation.Bundle {
    static var module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("CrossfitPRPackages_Localization.bundle").path
        let buildPath = "/Users/douglastaquary/Documents/Projects/Github/iOS/CrossfitPR/.build/x86_64-apple-macosx/debug/CrossfitPRPackages_Localization.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}