//
//  SurLeQuaiWidgetLiveActivity.swift
//  SurLeQuaiWidget
//
//  Created by Nicolas Klutchnikoff on 24/01/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SurLeQuaiWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SurLeQuaiWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SurLeQuaiWidgetAttributes.self) { context in
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

extension SurLeQuaiWidgetAttributes {
    fileprivate static var preview: SurLeQuaiWidgetAttributes {
        SurLeQuaiWidgetAttributes(name: "World")
    }
}

extension SurLeQuaiWidgetAttributes.ContentState {
    fileprivate static var smiley: SurLeQuaiWidgetAttributes.ContentState {
        SurLeQuaiWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SurLeQuaiWidgetAttributes.ContentState {
         SurLeQuaiWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SurLeQuaiWidgetAttributes.preview) {
   SurLeQuaiWidgetLiveActivity()
} contentStates: {
    SurLeQuaiWidgetAttributes.ContentState.smiley
    SurLeQuaiWidgetAttributes.ContentState.starEyes
}
