import SwiftUI

struct OnboardingView: View {
    @Binding var onboardingComplete: Bool
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "🔥",
            title: "Welcome to\nRizz AI",
            subtitle: "Your AI-powered dating assistant that lives right in your keyboard.",
            gradient: [Color(hex: "#FF2D55"), Color(hex: "#FF6B6B")]
        ),
        OnboardingPage(
            icon: "⌨️",
            title: "Smart Keyboard\nSuggestions",
            subtitle: "Get instant, context-aware rizz lines, openers, and witty replies — right as you type.",
            gradient: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")]
        ),
        OnboardingPage(
            icon: "🎯",
            title: "Tailored to\nYour Style",
            subtitle: "Choose your vibe — smooth, funny, bold, or poetic. We match your energy.",
            gradient: [Color(hex: "#F59E0B"), Color(hex: "#EF4444")]
        ),
        OnboardingPage(
            icon: "🔐",
            title: "Enable the\nKeyboard",
            subtitle: "Go to Settings → General → Keyboard → Keyboards → Add New → RizzAI to get started.",
            gradient: [Color(hex: "#10B981"), Color(hex: "#3B82F6")],
            isPermissionPage: true
        )
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: pages[currentPage].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)

            VStack(spacing: 0) {
                Spacer()

                // Icon
                Text(pages[currentPage].icon)
                    .font(.system(size: 90))
                    .padding(.bottom, 30)
                    .animation(.spring(), value: currentPage)

                // Title
                Text(pages[currentPage].title)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Subtitle
                Text(pages[currentPage].subtitle)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                if pages[currentPage].isPermissionPage {
                    Button(action: openSettings) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Open Settings")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(Color(hex: "#10B981"))
                        .cornerRadius(30)
                    }
                    .padding(.top, 30)
                }

                Spacer()

                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage ? Color.white : Color.white.opacity(0.4))
                            .frame(width: i == currentPage ? 10 : 7, height: i == currentPage ? 10 : 7)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 24)

                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button(action: { withAnimation { currentPage -= 1 } }) {
                            Text("Back")
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 16)
                        }
                    }
                    Spacer()

                    Button(action: {
                        withAnimation {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                onboardingComplete = true
                            }
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Let's Go 🔥" : "Next")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(pages[currentPage].gradient.first ?? .pink)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    var isPermissionPage: Bool = false
}
