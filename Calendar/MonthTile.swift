//
//  MonthTile.swift
//  CalendarExtension
//
//  Created by Sveagruva on 13.09.2022.
//

import SwiftUI
import WidgetKit

struct MonthTile: View {
    let entry: CalendarEntry
    let Month: Int
    let Year: Int

    static func getLastDayOfMonth(month: Int, year: Int) -> Int {
        var month = month
        var year = year
        if(month == 0) {
            year -= 1
            month = 12
        }

        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }

    init(
        entry: CalendarEntry,
        Month: Int,
        Year: Int
    ) {
        self.entry = entry
        self.Month = Month
        self.Year = Year

        var daysInOrder: [Int] = []
        daysInOrder.append(contentsOf: 1...MonthTile.getLastDayOfMonth(month: Month - 1, year: Year))
        daysInOrder.append(contentsOf: 1...MonthTile.getLastDayOfMonth(month: Month, year: Year))
        daysInOrder.append(contentsOf: 1...MonthTile.getLastDayOfMonth(month: Month + 1, year: Year))

        var pointer = MonthTile.getLastDayOfMonth(month: Month - 1, year: Year)

        let dayOfTheWeekForFirstDay = Calendar.current.component(.weekday, from: Calendar.current.date(from: DateComponents(year: Year, month: Month, day: 1))!)
        var movedBy = 0

        // not a monday
        if(dayOfTheWeekForFirstDay != 2) {
            if(dayOfTheWeekForFirstDay == 1) {
                movedBy = 6
            } else {
                movedBy = dayOfTheWeekForFirstDay - 2
            }
        }

        pointer -= movedBy

        days = daysInOrder
        startPointer = pointer
        daysInCurrentMonth = MonthTile.getLastDayOfMonth(month: Month, year: Year)
        isCurrentMonth = (Month == Calendar.current.component(.month, from: Date())) && (Year == Calendar.current.component(.year, from: Date()))
        todayDay = Calendar.current.component(.day, from: Date())
        movedByPoints = movedBy
    }

    // days in order from previous month, current month, next month
    let days: [Int]
    // index of last monday for previous month. if displaying month starts with monday then its index of first day
    let startPointer: Int
    // if displaying month is current month
    let isCurrentMonth: Bool
    let todayDay: Int
    let daysInCurrentMonth: Int
    // how many days startPointer was moved by backwards
    let movedByPoints: Int

    func createDayTileView(row: Int, column: Int) -> some View {
        let pointer = startPointer + row * 7 + column
        let backgroundSize = 2.0

        return VStack {
            Text(verbatim: "\(days[pointer])")
                .gridCellColumns(1)
                .font(.system(size: 12))
                .opacity((row * 7 + column < movedByPoints) || (row * 7 + column - movedByPoints + 1 > daysInCurrentMonth) ? 0.5 : 1)
        }
            .background {
                if(isCurrentMonth && days[pointer] == todayDay && !((row * 7 + column < movedByPoints) || (row * 7 + column - movedByPoints + 1 > daysInCurrentMonth))) {
                    Spacer()
                        .scaledToFit()
                        .background {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.secondary)
                                    .frame(width: geo.size.width + backgroundSize, height: geo.size.height + backgroundSize)
                                    .offset(x: -backgroundSize * 0.5, y: -backgroundSize * 0.5)
                                    .scaledToFit()
                            }
                        }
                }
            }
    }

    var body: some View {
        Grid() {
            GridRow {
                Text(verbatim: "\(DateFormatter().monthSymbols[Month-1].prefix(8)), \(Year)")
                    .gridCellColumns(7)
            }
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 1)
            GridRow {
                Text("M")
                Text("T")
                Text("W")
                Text("T")
                Text("F")
                Text("S")
                Text("S")
            }
            ForEach(0..<6) { row in
                GridRow {
                    ForEach(0..<7) { col in
                        createDayTileView(row: row, column: col)
                    }
                }
            }
        }
        .font(.system(size: 16))
    }
}

struct MonthTile_Previews: PreviewProvider {
    static var previews: some View {
        MonthTile(
            entry: CalendarEntry(date: Date(), configuration: ConfigurationIntent()),
            Month: 1,
            Year: 2022
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))

    }
}
