import SwiftUI

struct StatCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Spacer()

                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
            }

            Text("\(count)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            Text(count == 1 ? "event" : "events")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct LargeStatCard: View {
    let title: String
    let count: Int
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.primary)

                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)

                Spacer()
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)

                Text(count == 1 ? "event" : "events")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.textSecondary)

                Spacer()
            }

            Text(subtitle)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            StatCard(title: "Today", count: 3, icon: "sun.max.fill", color: Theme.primary)
            StatCard(title: "Week", count: 12, icon: "calendar", color: Theme.secondary)
        }

        LargeStatCard(
            title: "This Month",
            count: 45,
            subtitle: "Keep tracking to understand your patterns",
            icon: "chart.bar.fill"
        )
    }
    .padding()
    .gradientBackground()
}
