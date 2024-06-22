import Foundation

extension Date {
    func formate(_ formate: String = "dd.MM.yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.locale = .init(identifier: "en")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var components: DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents(
            [.year, .month, .day, .hour, .weekday], from: self
        )
    }
    
    var day: Int {
        components.day ?? 0
    }
    
    func isEqual(to date: Date) -> Bool {
        let selfDate = self.formate("MM/dd/yyyy").date()
        let date = date.formate("MM/dd/yyyy").date()
        return selfDate == date
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension String {
    func date() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        return dateFormatter.date(from: self) ?? Date()
    }
}
