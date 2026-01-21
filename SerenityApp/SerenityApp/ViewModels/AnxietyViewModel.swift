import Foundation
import SwiftData
import SwiftUI

@Observable
class AnxietyViewModel {
    private var modelContext: ModelContext?

    var todayCount: Int = 0
    var weekCount: Int = 0
    var monthCount: Int = 0
    var isLoading: Bool = false
    var showSuccess: Bool = false

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        refreshStats()
    }

    func recordAnxietyEvent() {
        guard let context = modelContext else { return }

        let record = AnxietyRecord()
        context.insert(record)

        do {
            try context.save()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                showSuccess = true
            }
            refreshStats()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.showSuccess = false
                }
            }
        } catch {
            print("Failed to save anxiety record: \(error)")
        }
    }

    func refreshStats() {
        guard let context = modelContext else { return }

        let today = Date()

        // Today's count
        todayCount = fetchCount(context: context, from: today.startOfDay, to: today.endOfDay)

        // Week count
        weekCount = fetchCount(context: context, from: today.startOfWeek, to: today.endOfWeek)

        // Month count
        monthCount = fetchCount(context: context, from: today.startOfMonth, to: today.endOfMonth)
    }

    private func fetchCount(context: ModelContext, from startDate: Date, to endDate: Date) -> Int {
        let predicate = #Predicate<AnxietyRecord> { record in
            record.timestamp >= startDate && record.timestamp <= endDate
        }

        let descriptor = FetchDescriptor<AnxietyRecord>(predicate: predicate)

        do {
            let records = try context.fetch(descriptor)
            return records.count
        } catch {
            print("Failed to fetch records: \(error)")
            return 0
        }
    }

    func fetchRecords(from startDate: Date, to endDate: Date) -> [AnxietyRecord] {
        guard let context = modelContext else { return [] }

        let predicate = #Predicate<AnxietyRecord> { record in
            record.timestamp >= startDate && record.timestamp <= endDate
        }

        let descriptor = FetchDescriptor<AnxietyRecord>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch records: \(error)")
            return []
        }
    }

    func countByDay(from startDate: Date, to endDate: Date) -> [(date: Date, count: Int)] {
        let records = fetchRecords(from: startDate, to: endDate)
        let days = startDate.daysInRange(to: endDate)

        return days.map { day in
            let dayKey = AnxietyRecord.dayKey(for: day)
            let count = records.filter { $0.dayKey == dayKey }.count
            return (date: day, count: count)
        }
    }
}
