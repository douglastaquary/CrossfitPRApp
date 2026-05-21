import Foundation
import UserNotifications
import UIKit

/// Gerencia permissões e agendamento de notificações locais.
@MainActor
public final class LocalNotificationManager: NSObject, ObservableObject {
    private let notificationCenter = UNUserNotificationCenter.current()

    @Published public private(set) var isGranted = false
    @Published public private(set) var pendingRequests: [UNNotificationRequest] = []

    public override init() {
        super.init()
        notificationCenter.delegate = self
    }

    public func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        registerActions()
        await refreshSettings()
    }

    public func refreshSettings() async {
        let settings = await notificationCenter.notificationSettings()
        isGranted = settings.authorizationStatus == .authorized
    }

    public func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        if let subtitle = localNotification.subtitle {
            content.subtitle = subtitle
        }
        if let categoryIdentifier = localNotification.categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        content.sound = .default

        let trigger: UNNotificationTrigger?
        switch localNotification.scheduleType {
        case .time:
            guard let interval = localNotification.timeInterval else { return }
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: localNotification.repeats)
        case .calendar:
            guard let components = localNotification.dateComponents else { return }
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: localNotification.repeats)
        }

        guard let trigger else { return }
        let request = UNNotificationRequest(
            identifier: localNotification.identifier,
            content: content,
            trigger: trigger
        )
        try? await notificationCenter.add(request)
        await refreshPendingRequests()
    }

    public func refreshPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
    }

    public func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
    }

    public func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        Task { await UIApplication.shared.open(url) }
    }

    private func registerActions() {
        let snooze10 = UNNotificationAction(identifier: "snooze10", title: "Snooze 10 seconds")
        let snooze60 = UNNotificationAction(identifier: "snooze60", title: "Snooze 60 seconds")
        let category = UNNotificationCategory(
            identifier: "snooze",
            actions: [snooze10, snooze60],
            intentIdentifiers: []
        )
        notificationCenter.setNotificationCategories([category])
    }
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        await refreshPendingRequests()
        return [.sound, .banner]
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        var snoozeInterval: TimeInterval?
        switch response.actionIdentifier {
        case "snooze10": snoozeInterval = 10
        case "snooze60": snoozeInterval = 60
        default: break
        }

        if let snoozeInterval {
            let content = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeInterval, repeats: false)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            try? await notificationCenter.add(request)
            await refreshPendingRequests()
        }
    }
}

public extension String {
    static func randomNotificationMessage(list: [String]) -> String {
        list.randomElement() ?? list[0]
    }
}
