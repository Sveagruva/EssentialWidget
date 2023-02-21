//
//  widgetsIOS.swift
//  widgetsIOS
//
//  Created by Sveagruva on 2/21/23.
//

import WidgetKit
import SwiftUI
import Intents


struct widgetsIOS: Widget {
    let kind: String = "widgetsIOS"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CalendarEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])

    }
}
