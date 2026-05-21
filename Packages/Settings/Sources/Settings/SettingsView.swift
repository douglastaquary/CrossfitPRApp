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
            Section(Strings.Settings.notificationSection) {
                Toggle(isOn: $settingsClient.isNotificationEnabled) {
                    Text(Strings.Settings.notificationToggle)
                }
                .onChange(of: settingsClient.isNotificationEnabled) { enabled in
                    if !enabled { notificationManager.clearRequests() }
                }

                DatePicker(selection: scheduleDateBinding) {
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundStyle(AppDesign.Colors.brand)
                }
            }

            Section(Strings.Settings.trackingSection) {
                Picker(
                    selection: $settingsClient.measureTrackingMode,
                    label: Text(Strings.Settings.measureTitle)
                ) {
                    ForEach(MeasureTrackingMode.allCases, id: \.self) { mode in
                        Text(Strings.tr(mode.localizationKey)).tag(mode)
                    }
                }
            }

            Section(Strings.Settings.proSection) {
                if subscriptionClient.currentTier == .pro {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(AppDesign.Colors.proAccent)
                        Text("Assinatura PRO ativa")
                            .foregroundStyle(.primary)
                    }

                    Button(role: .destructive) {
                        showCancelAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Cancelar assinatura")
                        }
                    }
                } else {
                    Button {
                        showPROUpgrade = true
                    } label: {
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
        .navigationTitle(Strings.Screen.settings)
        .sheet(isPresented: $showPROUpgrade) {
            PROUpgradeView()
        }
        .alert("Cancelar assinatura?", isPresented: $showCancelAlert) {
            Button("Manter PRO", role: .cancel) {}
            Button("Sim, cancelar", role: .destructive) {
                Task {
                    await cancelSubscription()
                }
            }
        } message: {
            Text("Ao cancelar, você perderá acesso aos insights avançados, metas personalizadas e projeções de PR. Tem certeza?")
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
