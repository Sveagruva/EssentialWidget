//
//  widgetsMacOS.swift
//  widgetsMacOS
//
//  Created by Sveagruva on 2/21/23.
//

import WidgetKit
import SwiftUI
import Intents


@main
struct widgetsMacOS: Widget {
    let kind: String = "widgetsMacOS"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CalendarEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar widgets")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])

    }
}
