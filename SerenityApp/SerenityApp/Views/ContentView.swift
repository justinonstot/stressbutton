import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AnxietyViewModel()
    @State private var showDashboard = false
    private let audioService = AudioService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Theme.gradientStart, Theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    header
                        .padding(.top, 20)

                    Spacer()

                    // Main button area
                    VStack(spacing: 30) {
                        // Pulsing background circles
                        ZStack {
                            PulsingCircle()
                            PulsingCircle()
                                .rotationEffect(.degrees(60))

                            SerenityButton {
                                handleSerenityTap()
                            }
                        }

                        // Success feedback
                        if viewModel.showSuccess {
                            successMessage
                                .transition(.scale.combined(with: .opacity))
                        }
                    }

                    Spacer()

                    // Stats overview
                    statsOverview
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Dashboard button
                    dashboardButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $showDashboard) {
                DashboardView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Serenity")
                .font(.system(size: 32, weight: .light, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            Text("Track your moments, find your calm")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(Theme.textSecondary)
        }
    }

    private var successMessage: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

            Text("Moment recorded")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.9))
        .cornerRadius(25)
        .shadow(color: Theme.shadowColor, radius: 10)
    }

    private var statsOverview: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Today",
                count: viewModel.todayCount,
                icon: "sun.max.fill",
                color: Theme.primary
            )

            StatCard(
                title: "This Week",
                count: viewModel.weekCount,
                icon: "calendar",
                color: Theme.accent
            )
        }
    }

    private var dashboardButton: some View {
        Button(action: { showDashboard = true }) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 18, weight: .medium))

                Text("View Dashboard")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(Theme.textPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.shadowColor, radius: Theme.shadowRadius, x: 0, y: 4)
        }
    }

    private func handleSerenityTap() {
        // Play calming tones
        audioService.playSerenityTones()

        // Record the event
        viewModel.recordAnxietyEvent()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AnxietyRecord.self, inMemory: true)
}
