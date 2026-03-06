import SwiftUI

struct StyleView: View {
    @AppStorage("rizzStyle") private var rizzStyle = RizzStyle.smooth.rawValue
    @AppStorage("openAIKey") private var openAIKey = ""
    @State private var showAPIKeyAlert = false
    @State private var tempKey = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Style picker header
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        VStack(spacing: 8) {
                            Text("✨ Your Rizz Style")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            Text("Pick your personality for AI suggestions")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(24)
                    }
                    .padding(.horizontal)

                    // Style grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(RizzStyle.allCases) { style in
                            StyleCard(
                                style: style,
                                isSelected: rizzStyle == style.rawValue
                            ) {
                                rizzStyle = style.rawValue
                            }
                        }
                    }
                    .padding(.horizontal)

                    // API Key section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🤖 AI Power")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("OpenAI API Key")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)

                            HStack {
                                SecureField("sk-...", text: $openAIKey)
                                    .font(.system(size: 14, design: .monospaced))
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)

                                if !openAIKey.isEmpty {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }

                            Text("Add your OpenAI key to unlock GPT-4 powered suggestions. Without it, the app uses our built-in library.")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)
                    }

                    // Keyboard setup reminder
                    VStack(alignment: .leading, spacing: 10) {
                        Text("⌨️ Keyboard Setup")
                            .font(.system(size: 16, weight: .semibold))

                        Text("1. Open iPhone Settings\n2. General → Keyboard → Keyboards\n3. Add New Keyboard → RizzAI\n4. Enable 'Allow Full Access'")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)

                        Button(action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }) {
                            Label("Go to Settings", systemImage: "gear")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#8B5CF6"))
                                .cornerRadius(12)
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)

                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
            .navigationTitle("Style 💅")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StyleCard: View {
    let style: RizzStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(style.emoji)
                    .font(.system(size: 36))
                Text(style.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
                Text(style.description)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .white.opacity(0.85) : .secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(hex: "#8B5CF6") : Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "#8B5CF6") : Color.clear, lineWidth: 2)
            )
        }
    }
}
