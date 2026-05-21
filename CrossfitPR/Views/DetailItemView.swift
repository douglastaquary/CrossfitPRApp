//
//  DetailItemView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI

struct DetailItemView: View {
    var model: RecordModel
    var toggle: () -> ()

    var body: some View {
        VStack(spacing: 8) {
            Button(action: { withAnimation { toggle() } }) {
                Image(systemName: model.imageSystemName).foregroundColor(.green)
            }
            .frame(alignment: .leading)

            Text(model.value)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

           // if !reminder.markedCompleted {
            Text(LocalizedStringKey(model.name))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
           // }
        }
        .accessibilityElement(children: .combine)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(8)
        .customBackground(color: .background)
    }

    private func getDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMM, dd"
        return format.string(from: model.date ?? Date())
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemView(model: RecordModel(), toggle: {})
    }
}



struct RecordModel: Identifiable, Hashable {
    var id = UUID()
    var imageSystemName: String = ""
    var name: String = ""
    var value: String = ""
    var date: Date?
    var markedCompleted = false
}

extension RecordModel {
    static func testRecordModels() -> [RecordModel] {
        var models: [RecordModel] = []

        for _ in 0..<12 {
            models.append(RecordModel())
        }

        return models
    }
}

extension RecordModel {
    static let defaultReminderName = "Snatch"
}
