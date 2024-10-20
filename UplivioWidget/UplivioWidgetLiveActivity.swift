//
//  UplivioWidgetLiveActivity.swift
//  UplivioWidget
//
//  Created by Sümeyra Demirtaş on 10/19/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct UplivioWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct UplivioWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UplivioWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension UplivioWidgetAttributes {
    fileprivate static var preview: UplivioWidgetAttributes {
        UplivioWidgetAttributes(name: "World")
    }
}

extension UplivioWidgetAttributes.ContentState {
    fileprivate static var smiley: UplivioWidgetAttributes.ContentState {
        UplivioWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: UplivioWidgetAttributes.ContentState {
         UplivioWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: UplivioWidgetAttributes.preview) {
   UplivioWidgetLiveActivity()
} contentStates: {
    UplivioWidgetAttributes.ContentState.smiley
    UplivioWidgetAttributes.ContentState.starEyes
}
