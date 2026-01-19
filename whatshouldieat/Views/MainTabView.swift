import SwiftUI

struct MainTabView: View {
    @State private var selection: AppTab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(AppTab.home)

            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
                .tag(AppTab.discover)

            TrackView()
                .tabItem {
                    Label("Track", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(AppTab.track)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(AppTab.profile)
        }
        .tint(Color(hex: 0xF0D9C2))
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

private enum AppTab {
    case home
    case discover
    case track
    case profile
}

#Preview {
    MainTabView()
}
