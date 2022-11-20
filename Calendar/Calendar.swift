//
//  Calendar.swift
//  Calendar
//
//  Created by Sveagruva on 13.09.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = CalendarEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CalendarEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CalendarEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CalendarEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var fam

    let familyToLayoutSize: [WidgetFamily: Int] = [
        .systemMedium: 2,
        .systemLarge: 4,
        .systemExtraLarge: 8,
    ]

    var body: some View {
        let parts = Calendar.current.dateComponents([.month, .year], from: entry.date)
        var month: Int = parts.month!
        var year: Int = parts.year!

        var views: [MonthTile] = []
        let layout: Int = familyToLayoutSize[fam]!
        let _ = (0..<layout).forEach { i in
            views.append(MonthTile(entry: entry, Month: month, Year: year))
            month += 1
            if(month == 13) {
                month = 1
                year += 1
            }
        }

        switch fam {
        case .systemMedium:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    views[0]
                    Spacer()
                    views[1]
                    Spacer()
                }
                Spacer()
            }
        case .systemLarge:
            VStack {
                Spacer()
                HStack {
                   Spacer()
                   views[0]
                   Spacer()
                   views[1]
                   Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    views[2]
                    Spacer()
                    views[3]
                    Spacer()
                }
                Spacer()
            }
        case .systemExtraLarge:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    views[0]
                    Spacer()
                    views[1]
                    Spacer()
                    views[2]
                    Spacer()
                    views[3]
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    views[4]
                    Spacer()
                    views[5]
                    Spacer()
                    views[6]
                    Spacer()
                    views[7]
                    Spacer()
                }
                Spacer()
            }
        default:
            views[0]
        }
    }
}

@main
struct CalendarWidget: Widget {
    let kind: String = "Calendar"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            CalendarEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar")
        .description("Calendar widget")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEntryView(entry: CalendarEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CalendarEntryView(entry: CalendarEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        CalendarEntryView(entry: CalendarEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
