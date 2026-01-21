import Foundation
import SwiftData

@Model
final class AnxietyRecord {
    var timestamp: Date
    var dayKey: String

    init(timestamp: Date = Date()) {
        self.timestamp = timestamp
        self.dayKey = AnxietyRecord.dayKeyFormatter.string(from: timestamp)
    }

    static let dayKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func dayKey(for date: Date) -> String {
        return dayKeyFormatter.string(from: date)
    }
}

extension AnxietyRecord {
    static func predicate(for date: Date) -> Predicate<AnxietyRecord> {
        let key = dayKey(for: date)
        return #Predicate<AnxietyRecord> { record in
            record.dayKey == key
        }
    }

    static func predicate(from startDate: Date, to endDate: Date) -> Predicate<AnxietyRecord> {
        return #Predicate<AnxietyRecord> { record in
            record.timestamp >= startDate && record.timestamp <= endDate
        }
    }
}
