import SwiftUI
import Domain
import Application
import Localization

public struct PRHistoriesListView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @State private var isPresentingNewPR = false

    public enum ViewState: Equatable {
        case loading
        case loaded
        case error(String)
    }

    @State private var viewState: ViewState = .loading

    public init() {}

    public var body: some View {
        NavigationStack {
            Group {
                switch viewState {
                case .loading:
                    ProgressView(Strings.PRHistory.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error(let message):
                    EmptyStateView(
                        title: Strings.PRHistory.errorTitle,
                        systemImage: AppDesign.Icon.error,
                        message: message,
                        actionTitle: Strings.PRHistory.retry
                    ) {
                        Task { await loadRecords() }
                    }

                case .loaded:
                    if personalRecordClient.records.isEmpty {
                        EmptyStateView(
                            title: Strings.PRHistory.emptyTitle,
                            systemImage: AppDesign.Icon.emptyPRs,
                            message: Strings.PRHistory.emptyMessage
                        )
                    } else {
                        List(personalRecordClient.records) { record in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.exercise.kind.localizedName)
                                        .font(AppDesign.Typography.rowTitle)
                                    Text(record.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(AppDesign.Typography.rowSubtitle)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(Strings.NewPR.weight(Int(record.pounds)))
                                    .font(AppDesign.Typography.rowValue)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .refreshable {
                            await loadRecords()
                        }
                    }
                }
            }
            .navigationTitle(Strings.PRHistory.title)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(Strings.PRHistory.registerButton) {
                        isPresentingNewPR = true
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewPR) {
                NewPRRecordView()
            }
            .task {
                await loadRecords()
            }
            .redacted(reason: personalRecordClient.isLoading ? .placeholder : [])
        }
    }

    private func loadRecords() async {
        viewState = .loading
        await personalRecordClient.fetchRecords()
        if let error = personalRecordClient.lastError {
            viewState = .error(error)
        } else {
            viewState = .loaded
        }
    }
}
