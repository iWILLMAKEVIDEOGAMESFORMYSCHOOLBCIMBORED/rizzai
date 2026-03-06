import SwiftUI

struct SettingsView: View {
    @AppStorage("onboardingComplete") private var onboardingComplete = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("autocopyEnabled") private var autocopyEnabled = false
    @AppStorage("openAIKey") private var openAIKey = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Keyboard")) {
                    Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                    Toggle("Auto-Copy on Tap", isOn: $autocopyEnabled)
                }

                Section(header: Text("AI Settings")) {
                    HStack {
                        Text("API Key")
                        Spacer()
                        Text(openAIKey.isEmpty ? "Not Set" : "●●●●●●●●")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14, design: openAIKey.isEmpty ? .default : .monospaced))
                    }
                }

                Section(header: Text("App")) {
                    Button("Replay Onboarding") {
                        onboardingComplete = false
                    }
                    .foregroundColor(Color(hex: "#FF2D55"))

                    Link("Rate Rizz AI ⭐️", destination: URL(string: "https://apps.apple.com")!)
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings ⚙️")
        }
    }
}
