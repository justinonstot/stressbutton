import SwiftUI

struct Theme {
    // Primary colors - calming palette
    static let primary = Color(red: 0.47, green: 0.67, blue: 0.76)         // Soft teal
    static let primaryDark = Color(red: 0.35, green: 0.55, blue: 0.65)     // Darker teal
    static let secondary = Color(red: 0.73, green: 0.85, blue: 0.80)       // Sage green
    static let accent = Color(red: 0.58, green: 0.75, blue: 0.85)          // Sky blue

    // Background colors
    static let background = Color(red: 0.96, green: 0.97, blue: 0.98)      // Off-white
    static let cardBackground = Color.white
    static let gradientStart = Color(red: 0.92, green: 0.95, blue: 0.98)   // Light blue-gray
    static let gradientEnd = Color(red: 0.96, green: 0.94, blue: 0.97)     // Light lavender

    // Text colors
    static let textPrimary = Color(red: 0.20, green: 0.25, blue: 0.30)     // Dark gray
    static let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.55)   // Medium gray
    static let textLight = Color.white

    // Button colors
    static let serenityButtonGradient = LinearGradient(
        colors: [
            Color(red: 0.47, green: 0.67, blue: 0.76),
            Color(red: 0.58, green: 0.75, blue: 0.85),
            Color(red: 0.65, green: 0.80, blue: 0.88)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let serenityButtonPressedGradient = LinearGradient(
        colors: [
            Color(red: 0.35, green: 0.55, blue: 0.65),
            Color(red: 0.45, green: 0.63, blue: 0.73),
            Color(red: 0.52, green: 0.68, blue: 0.78)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Chart colors
    static let chartColors: [Color] = [
        Color(red: 0.47, green: 0.67, blue: 0.76),
        Color(red: 0.73, green: 0.85, blue: 0.80),
        Color(red: 0.85, green: 0.75, blue: 0.85),
        Color(red: 0.95, green: 0.80, blue: 0.70),
        Color(red: 0.70, green: 0.80, blue: 0.95)
    ]

    // Shadows
    static let shadowColor = Color.black.opacity(0.08)
    static let shadowRadius: CGFloat = 10

    // Corner radius
    static let cornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 100

    // Animation
    static let animationDuration: Double = 0.3
}

// Background gradient modifier
struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [Theme.gradientStart, Theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackground())
    }
}

// Card style modifier
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.shadowColor, radius: Theme.shadowRadius, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
