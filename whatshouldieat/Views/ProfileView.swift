import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let profileItems = ProfileItem.sample

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader(palette: palette)
                    accountSection(palette: palette)
                    signOutButton(palette: palette)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .background(palette.background.ignoresSafeArea())
            .safeAreaInset(edge: .top, spacing: 0) {
                header(palette: palette)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: ProfileDestination.self) { destination in
                switch destination {
                case .personalGoals:
                    PersonalGoalsView()
                case .favoriteMeals:
                    FavoriteMealsView()
                case .eatingHistory:
                    EatingHistoryView()
                case .appSettings:
                    AppSettingsView()
                case .support:
                    SupportView()
                }
            }
        }
    }

    private func header(palette: ProfilePalette) -> some View {
        HStack {
            Text("Profile")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
            Spacer()
            NavigationLink(value: ProfileDestination.appSettings) {
                Image(systemName: "gearshape")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(palette.brandOrange)
                    .frame(width: 36, height: 36)
                    .background(palette.primary.opacity(0.2))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border.opacity(0.4)),
            alignment: .bottom
        )
    }

    private func profileHeader(palette: ProfilePalette) -> some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .stroke(palette.primary.opacity(0.4), lineWidth: 4)
                    .frame(width: 112, height: 112)

                AsyncImage(url: URL(string: ProfileBadge.avatarURL)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(palette.primary.opacity(0.3))
                }
                .frame(width: 96, height: 96)
                .clipShape(Circle())

                Text("LVL 24")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(palette.brandOrange)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(palette.background, lineWidth: 2)
                    )
                    .offset(x: 6, y: 2)
            }

            Text("Alex Johnson")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
        }
        .padding(.top, 10)
    }

    private func accountSection(palette: ProfilePalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account & Goals")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
                .tracking(1)

            ForEach(profileItems) { item in
                NavigationLink(value: item.destination) {
                    ProfileRow(item: item, palette: palette)
                }
                .buttonStyle(.plain)
            }

            Text("Preferences")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
                .tracking(1)
                .padding(.top, 4)

            ForEach(ProfileItem.preferences) { item in
                NavigationLink(value: item.destination) {
                    ProfileRow(item: item, palette: palette)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func signOutButton(palette: ProfilePalette) -> some View {
        Button { } label: {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.red.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

private struct ProfileRow: View {
    let item: ProfileItem
    let palette: ProfilePalette

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.iconBackground)
                    .frame(width: 40, height: 40)
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(item.iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.text)
                Text(item.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(palette.mutedText)
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(18)
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(palette.border.opacity(0.4), lineWidth: 1)
        )
    }
}

private enum ProfileBadge {
    static let avatarURL =
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3"
}

private struct ProfileItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let iconBackground: Color
    let iconColor: Color
    let destination: ProfileDestination

    static let sample: [ProfileItem] = [
        ProfileItem(
            title: "Personal Goals",
            subtitle: "Weight, calorie target, macros",
            icon: "target",
            iconBackground: Color(hex: 0xFFEDD5),
            iconColor: Color(hex: 0xEA580C),
            destination: .personalGoals
        ),
        ProfileItem(
            title: "Favorite Meals",
            subtitle: "Saved recipes from 12 countries",
            icon: "heart.fill",
            iconBackground: Color(hex: 0xFEE2E2),
            iconColor: Color(hex: 0xDC2626),
            destination: .favoriteMeals
        ),
        ProfileItem(
            title: "Eating History",
            subtitle: "Your past month nutrition summary",
            icon: "clock.arrow.circlepath",
            iconBackground: Color(hex: 0xDBEAFE),
            iconColor: Color(hex: 0x2563EB),
            destination: .eatingHistory
        ),
    ]

    static let preferences: [ProfileItem] = [
        ProfileItem(
            title: "App Settings",
            subtitle: "Privacy, notifications, theme",
            icon: "gearshape",
            iconBackground: Color(hex: 0xF3F4F6),
            iconColor: Color(hex: 0x111827),
            destination: .appSettings
        ),
        ProfileItem(
            title: "Support & Feedback",
            subtitle: "Get help or request a feature",
            icon: "questionmark.circle",
            iconBackground: Color(hex: 0xDCFCE7),
            iconColor: Color(hex: 0x16A34A),
            destination: .support
        ),
    ]
}

private enum ProfileDestination: Hashable {
    case personalGoals
    case favoriteMeals
    case eatingHistory
    case appSettings
    case support
}

#Preview {
    ProfileView()
}
