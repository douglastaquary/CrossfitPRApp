//
//  CrossFitPRActivityWidget.swift
//  CrossFitPRActivityWidget
//
//  Created by Douglas Taquary on 18/09/22.
//

import Foundation
import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.1, *)
struct CrossfitAttributes: ActivityAttributes {
    public typealias Status = ContentState
    
    public struct ContentState: Codable, Hashable {
        var value: String
    }
    
    var inputValue: String
}

@available(iOS 16.1, *)
struct CrossFitPRActivityWidgetEntryView : View {
    var state: CrossfitAttributes.ContentState

    var body: some View {
        VStack {
            Text("Hello Live Activity")
            Text(state.value)
        }
    }
}

@available(iOS 16.1, *)
struct CrossFitPRActivityWidget: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CrossfitAttributes.self) { context in
            CrossFitPRActivityWidgetEntryView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    CrossFitPRActivityWidgetEntryView(state: context.state)
                }
            } compactLeading: {
                Image(systemName: "circle")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("Demo Dynamic Island")
            } minimal: {
                Text("Empty")
            }

        }
    }
}
//
//struct CrossFitPRActivityWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        CrossFitPRActivityWidgetEntryView(state: , configuration: ConfigurationIntent())
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
