import Domain

public extension WorkoutCategory {
    var localizedTitle: String {
        Strings.tr(titleKey)
    }
}

public extension String {
    /// Localiza nome de exercício a partir do título canônico em `PersonalRecord.prName`.
    var localizedWorkoutTitle: String {
        CrossfitCatalog.category(forStoredTitle: self).map { Strings.tr($0.titleKey) } ?? self
    }
}

public extension RecordGroup {
    /// Nome curto do grupo para chips e listas.
    var localizedDisplayName: String {
        Strings.tr(localizationKey)
    }

    /// Chave `Localizable.strings` do grupo (CategoryItemView, chips).
    var localizationKey: String {
        switch self {
        case .barbell: return "category.group.barbell.descript"
        case .gymnastic: return "category.group.gymnastic.descript"
        case .endurance: return "category.group.endurance.descript"
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
