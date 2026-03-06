import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: RizzCategory = .openers
    @State private var generatedLines: [String] = []
    @State private var isLoading = false
    @State private var context = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Header card
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#FF2D55"), Color(hex: "#FF6B6B")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🔥 Rizz Generator")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            Text("Generate lines based on context")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))

                            TextField("Describe the situation... (e.g. 'she loves dogs')", text: $context)
                                .padding(12)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                                .padding(.top, 4)
                        }
                        .padding(20)
                    }
                    .padding(.horizontal)

                    // Category picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(RizzCategory.allCases) { cat in
                                CategoryPill(category: cat, isSelected: selectedCategory == cat) {
                                    selectedCategory = cat
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Generate button
                    Button(action: generateRizz) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "sparkles")
                                Text("Generate Rizz")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#FF2D55"))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .disabled(isLoading)

                    // Generated lines
                    if !generatedLines.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Generated Lines")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal)

                            ForEach(generatedLines, id: \.self) { line in
                                RizzLineCard(line: line)
                                    .padding(.horizontal)
                            }
                        }
                    } else {
                        // Default examples
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Examples")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal)

                            ForEach(selectedCategory.examples, id: \.self) { line in
                                RizzLineCard(line: line)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
            .navigationTitle("Rizz AI 🔥")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    func generateRizz() {
        isLoading = true
        generatedLines = []

        // Uses RizzEngine to generate lines
        Task {
            let lines = await RizzEngine.shared.generateLines(
                category: selectedCategory,
                context: context.isEmpty ? nil : context
            )
            await MainActor.run {
                generatedLines = lines
                isLoading = false
            }
        }
    }
}

struct CategoryPill: View {
    let category: RizzCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.emoji)
                Text(category.title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "#FF2D55") : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct RizzLineCard: View {
    let line: String
    @State private var copied = false

    var body: some View {
        HStack {
            Text(line)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Spacer()

            Button(action: copyLine) {
                Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                    .foregroundColor(copied ? .green : Color(hex: "#FF2D55"))
                    .font(.system(size: 18))
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    func copyLine() {
        UIPasteboard.general.string = line
        withAnimation {
            copied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { copied = false }
        }
    }
}
