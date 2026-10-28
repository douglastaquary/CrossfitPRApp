import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Detecção de Apple Intelligence on-device (CPR-007).
public enum CoachingRuntimeAvailability {
    public static var isOnDeviceAppleIntelligenceAvailable: Bool {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            return onDeviceModelAvailable
        }
        #endif
        return false
    }

    #if canImport(FoundationModels)
    @available(iOS 26.0, *)
    private static var onDeviceModelAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }
    #endif
}
