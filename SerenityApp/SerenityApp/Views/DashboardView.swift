import SwiftUI
import SwiftData

enum DateRangeOption: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case custom = "Custom"
}

struct DashboardView: View {
    @Bindable var viewModel: AnxietyViewModel
    @State private var selectedRange: DateRangeOption = .week
    @State private var selectedDate: Date = Date()
    @State private var customStartDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @State private var customEndDate: Date = Date()
    @State private var showDatePicker = false
    @State private var chartData: [DailyChartData] = []

    private var dateRange: (start: Date, end: Date) {
        switch selectedRange {
        case .day:
            return (selectedDate.startOfDay, selectedDate.endOfDay)
        case .week:
            return (selectedDate.startOfWeek, selectedDate.endOfWeek)
        case .month:
            return (selectedDate.startOfMonth, selectedDate.endOfMonth)
        case .custom:
            return (customStartDate.startOfDay, customEndDate.endOfDay)
        }
    }

    private var dateRangeTitle: String {
        switch selectedRange {
        case .day:
            return selectedDate.shortDateString
        case .week:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: dateRange.start)) - \(formatter.string(from: dateRange.end))"
        case .month:
            return selectedDate.monthYearString
        case .custom:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return "\(formatter.string(from: customStartDate)) - \(formatter.string(from: customEndDate))"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Range selector
                rangeSelector

                // Date navigation
                dateNavigation

                // Custom date picker
                if selectedRange == .custom {
                    customDatePickers
                }

                // Summary stats
                WeeklyTrendView(data: chartData)

                // Chart
                BarChartView(data: chartData, title: chartTitle)

                // Monthly summary card
                if selectedRange != .day {
                    monthlySummaryCard
                }
            }
            .padding(20)
        }
        .gradientBackground()
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadChartData()
        }
        .onChange(of: selectedRange) { _, _ in
            loadChartData()
        }
        .onChange(of: selectedDate) { _, _ in
            loadChartData()
        }
        .onChange(of: customStartDate) { _, _ in
            if selectedRange == .custom {
                loadChartData()
            }
        }
        .onChange(of: customEndDate) { _, _ in
            if selectedRange == .custom {
                loadChartData()
            }
        }
    }

    private var rangeSelector: some View {
        HStack(spacing: 8) {
            ForEach(DateRangeOption.allCases, id: \.self) { option in
                Button(action: { selectedRange = option }) {
                    Text(option.rawValue)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(selectedRange == option ? .white : Theme.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            selectedRange == option
                                ? Theme.primary
                                : Theme.cardBackground
                        )
                        .cornerRadius(20)
                        .shadow(color: selectedRange == option ? Theme.primary.opacity(0.3) : Theme.shadowColor, radius: 5)
                }
            }
        }
    }

    private var dateNavigation: some View {
        HStack {
            Button(action: navigatePrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primary)
                    .padding(12)
                    .background(Theme.cardBackground)
                    .cornerRadius(10)
            }

            Spacer()

            VStack(spacing: 4) {
                Text(dateRangeTitle)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)

                if selectedRange != .custom {
                    Button(action: { selectedDate = Date() }) {
                        Text("Today")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.primary)
                    }
                }
            }

            Spacer()

            Button(action: navigateNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primary)
                    .padding(12)
                    .background(Theme.cardBackground)
                    .cornerRadius(10)
            }
            .disabled(selectedRange == .custom || !canNavigateNext)
            .opacity(selectedRange == .custom || !canNavigateNext ? 0.5 : 1)
        }
        .padding(.horizontal, 4)
    }

    private var customDatePickers: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Date")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.textSecondary)

                    DatePicker("", selection: $customStartDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("End Date")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.textSecondary)

                    DatePicker("", selection: $customEndDate, in: customStartDate..., displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
            }
            .padding(16)
            .cardStyle()
        }
    }

    private var monthlySummaryCard: some View {
        LargeStatCard(
            title: "Period Summary",
            count: chartData.reduce(0) { $0 + $1.count },
            subtitle: "Total events in the selected period",
            icon: "chart.pie.fill"
        )
    }

    private var chartTitle: String {
        switch selectedRange {
        case .day:
            return "Hourly Breakdown"
        case .week:
            return "Daily Breakdown"
        case .month:
            return "Daily Breakdown"
        case .custom:
            return "Daily Breakdown"
        }
    }

    private var canNavigateNext: Bool {
        switch selectedRange {
        case .day:
            return selectedDate.startOfDay < Date().startOfDay
        case .week:
            return selectedDate.endOfWeek < Date()
        case .month:
            return selectedDate.endOfMonth < Date()
        case .custom:
            return false
        }
    }

    private func navigatePrevious() {
        switch selectedRange {
        case .day:
            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        case .week:
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
        case .month:
            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
        case .custom:
            break
        }
    }

    private func navigateNext() {
        guard canNavigateNext else { return }

        switch selectedRange {
        case .day:
            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        case .week:
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
        case .month:
            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
        case .custom:
            break
        }
    }

    private func loadChartData() {
        let dailyData = viewModel.countByDay(from: dateRange.start, to: dateRange.end)
        chartData = dailyData.map { DailyChartData(date: $0.date, count: $0.count) }
    }
}

#Preview {
    NavigationStack {
        DashboardView(viewModel: AnxietyViewModel())
    }
    .modelContainer(for: AnxietyRecord.self, inMemory: true)
}
