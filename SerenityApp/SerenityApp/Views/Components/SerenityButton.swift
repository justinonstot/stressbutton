import SwiftUI

struct SerenityButton: View {
    let action: () -> Void
    @State private var isPressed = false
    @State private var rippleScale: CGFloat = 0
    @State private var rippleOpacity: Double = 0

    private let buttonSize: CGFloat = 200

    var body: some View {
        ZStack {
            // Ripple effect
            Circle()
                .stroke(Theme.primary.opacity(0.3), lineWidth: 2)
                .frame(width: buttonSize * rippleScale, height: buttonSize * rippleScale)
                .opacity(rippleOpacity)

            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Theme.primary.opacity(0.3), Theme.primary.opacity(0)],
                        center: .center,
                        startRadius: buttonSize * 0.4,
                        endRadius: buttonSize * 0.7
                    )
                )
                .frame(width: buttonSize * 1.4, height: buttonSize * 1.4)
                .blur(radius: 20)

            // Main button
            Circle()
                .fill(isPressed ? Theme.serenityButtonPressedGradient : Theme.serenityButtonGradient)
                .frame(width: buttonSize, height: buttonSize)
                .shadow(color: Theme.primary.opacity(0.4), radius: isPressed ? 15 : 25, x: 0, y: isPressed ? 5 : 10)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.white)

                        Text("Serenity")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.white)

                        Text("Tap for calm")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                    triggerRipple()
                    action()
                }
        )
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: isPressed)
    }

    private func triggerRipple() {
        rippleScale = 1.0
        rippleOpacity = 0.8

        withAnimation(.easeOut(duration: 0.8)) {
            rippleScale = 2.0
            rippleOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            rippleScale = 0
        }
    }
}

struct PulsingCircle: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .stroke(Theme.primary.opacity(0.2), lineWidth: 1)
            .frame(width: 280, height: 280)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .opacity(isAnimating ? 0 : 0.5)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        SerenityButton {
            print("Button tapped")
        }
    }
}
