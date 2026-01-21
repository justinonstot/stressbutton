import SwiftUI
import Charts

struct DailyChartData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int

    var dayLabel: String {
        date.shortDayName
    }

    var dateLabel: String {
        date.dayNumber
    }
}

struct BarChartView: View {
    let data: [DailyChartData]
    let title: String

    private var maxCount: Int {
        max(data.map { $0.count }.max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            if data.isEmpty {
                emptyState
            } else {
                Chart(data) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.primary, Theme.accent],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                VStack(spacing: 2) {
                                    Text(date.shortDayName)
                                        .font(.system(size: 10))
                                    Text(date.dayNumber)
                                        .font(.system(size: 10, weight: .semibold))
                                }
                                .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                            .foregroundStyle(Theme.textSecondary.opacity(0.2))
                        AxisValueLabel()
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .chartYScale(domain: 0...(maxCount + 1))
                .frame(height: 200)
            }
        }
        .padding(20)
        .cardStyle()
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(Theme.textSecondary.opacity(0.5))

            Text("No data for this period")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
}

struct WeeklyTrendView: View {
    let data: [DailyChartData]

    private var totalCount: Int {
        data.reduce(0) { $0 + $1.count }
    }

    private var averageCount: Double {
        guard !data.isEmpty else { return 0 }
        return Double(totalCount) / Double(data.count)
    }

    private var trend: TrendDirection {
        guard data.count >= 2 else { return .neutral }
        let midpoint = data.count / 2
        let firstHalf = data.prefix(midpoint).reduce(0) { $0 + $1.count }
        let secondHalf = data.suffix(data.count - midpoint).reduce(0) { $0 + $1.count }

        if secondHalf < firstHalf {
            return .decreasing
        } else if secondHalf > firstHalf {
            return .increasing
        }
        return .neutral
    }

    enum TrendDirection {
        case increasing, decreasing, neutral

        var icon: String {
            switch self {
            case .increasing: return "arrow.up.right"
            case .decreasing: return "arrow.down.right"
            case .neutral: return "arrow.right"
            }
        }

        var color: Color {
            switch self {
            case .increasing: return .orange
            case .decreasing: return .green
            case .neutral: return Theme.textSecondary
            }
        }

        var message: String {
            switch self {
            case .increasing: return "Trending up this period"
            case .decreasing: return "Trending down - great progress!"
            case .neutral: return "Staying consistent"
            }
        }
    }

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)

                Text("\(totalCount)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }

            Divider()
                .frame(height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Avg")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)

                Text(String(format: "%.1f", averageCount))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: trend.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(trend.color)

                Text(trend.message)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(20)
        .cardStyle()
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            BarChartView(
                data: [
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 3),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 5),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 2),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 4),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 1),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 3),
                    DailyChartData(date: Date(), count: 2)
                ],
                title: "Last 7 Days"
            )

            WeeklyTrendView(
                data: [
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 3),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 5),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 2),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 4),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 1),
                    DailyChartData(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 3),
                    DailyChartData(date: Date(), count: 2)
                ]
            )
        }
        .padding()
    }
    .gradientBackground()
}
