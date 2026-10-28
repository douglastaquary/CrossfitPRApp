import Domain

public extension RecordGroup {
    /// Nome curto do grupo para chips e listas.
    var localizedDisplayName: String {
        switch self {
        case .barbell: return Strings.tr("category.group.barbell.descript")
        case .gymnastic: return Strings.tr("category.group.gymnastic.descript")
        case .endurance: return Strings.tr("category.group.endurance.descript")
        }
    }
}

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
