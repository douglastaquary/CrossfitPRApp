import Domain

public extension ActivityKind {
    /// Nome localizado do exercício para exibição na UI.
    var localizedName: String {
        Strings.Exercise.name(self)
    }
}

public extension ProFeature {
    /// Título de marketing localizado para telas PRO.
    var localizedMarketingTitle: String {
        Strings.ProFeatureCopy.marketingTitle(self)
    }
}

public extension PersonalRecordRepositoryError {
    /// Mensagem localizada para exibição na UI.
    var localizedMessage: String {
        Strings.ErrorCopy.repository(self)
    }
}

public extension SubscriptionError {
    /// Mensagem localizada para exibição na UI.
    var localizedMessage: String {
        Strings.ErrorCopy.subscription(self)
    }
}
