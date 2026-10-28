import SwiftUI
import Domain
import Application
import Subscription
import PROUpgrade
import SharedUI
import Localization

public struct SettingsView: View {
    @EnvironmentObject private var settingsClient: SettingsClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @EnvironmentObject private var notificationManager: LocalNotificationManager
    @State private var showPROUpgrade = false
    @State private var showCancelAlert = false
    @State private var scheduleDate = Date()

    public init() {}

    public var body: some View {
        Form {
            SettingsNotificationSection(
                isNotificationEnabled: $settingsClient.isNotificationEnabled,
                scheduleDate: scheduleDateBinding,
                onNotificationDisabled: { notificationManager.clearRequests() }
            )

            SettingsTrackingSection(measureTrackingMode: $settingsClient.measureTrackingMode)

            SettingsProSection(
                isPro: subscriptionClient.currentTier == .pro,
                onShowUpgrade: { showPROUpgrade = true },
                onShowCancelAlert: { showCancelAlert = true }
            )

            SettingsAboutSection()
        }
        .navigationTitle(Strings.Screen.settings)
        .sheet(isPresented: $showPROUpgrade) {
            PROUpgradeView()
        }
        .alert(Strings.Settings.Pro.cancelAlertTitle, isPresented: $showCancelAlert) {
            Button(Strings.Settings.Pro.cancelAlertKeep, role: .cancel) {}
            Button(Strings.Settings.Pro.cancelAlertConfirm, role: .destructive) {
                Task { await cancelSubscription() }
            }
        } message: {
            Text(Strings.Settings.Pro.cancelAlertMessage)
        }
        .task {
            try? await notificationManager.requestAuthorization()
        }
        .brandTint()
    }

    private var scheduleDateBinding: Binding<Date> {
        Binding(
            get: { scheduleDate },
            set: { newValue in
                scheduleDate = newValue
                Task { await scheduleNotification(at: newValue) }
            }
        )
    }

    private func scheduleNotification(at date: Date) async {
        guard settingsClient.isNotificationEnabled else { return }
        notificationManager.clearRequests()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let title = String.randomNotificationMessage(list: [
            "Hora de treinar! 💪🏼",
            "E ai?? Bora tirar o atraso?!",
        ])
        let body = String.randomNotificationMessage(list: [
            "Hoje o treino promete! 🏋🏻",
            "No pain, no gain! 😄",
        ])
        let notification = LocalNotification(
            identifier: UUID().uuidString,
            title: title,
            body: body,
            dateComponents: components,
            repeats: false
        )
        await notificationManager.schedule(localNotification: notification)
    }

    private func cancelSubscription() async {
        await subscriptionClient.cancelSubscription()
    }
}

// MARK: - Form sections

private struct SettingsNotificationSection: View {
    @Binding var isNotificationEnabled: Bool
    var scheduleDate: Binding<Date>
    let onNotificationDisabled: () -> Void

    var body: some View {
        Section(Strings.Settings.notificationSection) {
            Toggle(isOn: $isNotificationEnabled) {
                Text(Strings.Settings.notificationToggle)
            }
            .onChange(of: isNotificationEnabled) { enabled in
                if !enabled { onNotificationDisabled() }
            }

            DatePicker(selection: scheduleDate) {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundStyle(AppDesign.Colors.brand)
            }
        }
    }
}

private struct SettingsTrackingSection: View {
    @Binding var measureTrackingMode: MeasureTrackingMode

    var body: some View {
        Section(Strings.Settings.trackingSection) {
            Picker(
                selection: $measureTrackingMode,
                label: Text(Strings.Settings.measureTitle)
            ) {
                ForEach(MeasureTrackingMode.allCases, id: \.self) { mode in
                    Text(Strings.tr(mode.localizationKey)).tag(mode)
                }
            }
        }
    }
}

private struct SettingsProSection: View {
    let isPro: Bool
    let onShowUpgrade: () -> Void
    let onShowCancelAlert: () -> Void

    var body: some View {
        Section(Strings.Settings.proSection) {
            if isPro {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(AppDesign.Colors.proAccent)
                    Text(Strings.Settings.Pro.subscriptionActive)
                        .foregroundStyle(.primary)
                }

                Button(role: .destructive, action: onShowCancelAlert) {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text(Strings.Settings.Pro.cancelSubscription)
                    }
                }
            } else {
                Button(action: onShowUpgrade) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(AppDesign.Colors.proAccent)
                        Text(Strings.Settings.unlockPro)
                    }
                }

                Text(Strings.Settings.noCommitment)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct SettingsAboutSection: View {
    var body: some View {
        Section(Strings.Settings.aboutSection) {
            Link(destination: URL(string: "https://www.apple.com/legal/privacy/")!) {
                HStack {
                    Text(Strings.Settings.privacy)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
