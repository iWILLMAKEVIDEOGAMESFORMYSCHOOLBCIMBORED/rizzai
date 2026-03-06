import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @AppStorage("onboardingComplete") private var onboardingComplete = false

    var body: some View {
        if !onboardingComplete {
            OnboardingView(onboardingComplete: $onboardingComplete)
        } else {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "flame.fill")
                    }
                    .tag(0)

                StyleView()
                    .tabItem {
                        Label("Style", systemImage: "sparkles")
                    }
                    .tag(1)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
            .tint(Color("AccentPink"))
        }
    }
}
