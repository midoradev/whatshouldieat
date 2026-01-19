import SwiftUI

struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var mealRemindersEnabled = true
    @State private var darkThemeEnabled = false

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(title: "Privacy & Security", palette: palette)
                NavigationLink {
                    AccountPrivacyView()
                } label: {
                    SettingsRow(
                        icon: "lock",
                        title: "Account Privacy",
                        subtitle: "Manage data sharing and visibility",
                        iconBackground: Color(hex: 0xDBEAFE),
                        iconColor: Color(hex: 0x2563EB),
                        palette: palette,
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)

                SectionHeader(title: "Notifications", palette: palette)
                SettingsToggleRow(
                    icon: "bell.badge",
                    title: "Meal Reminders",
                    subtitle: "Daily prompts to log your nutrition",
                    iconBackground: palette.brandOrange.opacity(0.2),
                    iconColor: palette.brandOrange,
                    palette: palette,
                    isOn: $mealRemindersEnabled,
                    tint: palette.brandOrange
                )
                NavigationLink {
                    NotificationPreferencesView()
                } label: {
                    SettingsRow(
                        icon: "bell",
                        title: "Notification Preferences",
                        subtitle: "Customize sounds and alerts",
                        iconBackground: Color(hex: 0xFFF7ED),
                        iconColor: palette.brandOrange,
                        palette: palette,
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)

                SectionHeader(title: "Appearance & Locale", palette: palette)
                SettingsToggleRow(
                    icon: "moon.stars",
                    title: "Dark Theme",
                    subtitle: "Switch between light and dark mode",
                    iconBackground: Color(hex: 0xEDE9FE),
                    iconColor: Color(hex: 0x7C3AED),
                    palette: palette,
                    isOn: $darkThemeEnabled,
                    tint: Color(hex: 0x9CA3AF)
                )
                NavigationLink {
                    LanguageSelectionView()
                } label: {
                    SettingsRow(
                        icon: "globe",
                        title: "Language",
                        subtitle: "English (US)",
                        iconBackground: Color(hex: 0xDCFCE7),
                        iconColor: Color(hex: 0x16A34A),
                        palette: palette,
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)
                NavigationLink {
                    UnitsView()
                } label: {
                    SettingsRow(
                        icon: "ruler",
                        title: "Units",
                        subtitle: "Metric (kg, cm, kcal)",
                        iconBackground: Color(hex: 0xCCFBF1),
                        iconColor: Color(hex: 0x0F766E),
                        palette: palette,
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)

                SectionHeader(title: "About", palette: palette)
                SettingsRow(
                    icon: "info.circle",
                    title: "App Version",
                    subtitle: "v2.4.0 (Build 102)",
                    iconBackground: Color(hex: 0xF3F4F6),
                    iconColor: palette.text,
                    palette: palette,
                    showsChevron: false
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(palette.background.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            header(palette: palette)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func header(palette: ProfilePalette) -> some View {
        HStack(spacing: 8) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.brandOrange)
                    .frame(width: 36, height: 36)
                    .background(palette.primary.opacity(0.2))
                    .clipShape(Circle())
            }
            Text("App Settings")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
            Spacer()
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
}

private struct SectionHeader: View {
    let title: String
    let palette: ProfilePalette

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(palette.mutedText)
            .textCase(.uppercase)
            .tracking(1)
            .padding(.leading, 2)
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconBackground: Color
    let iconColor: Color
    let palette: ProfilePalette
    let showsChevron: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBackground)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.text)
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.mutedText)
            }
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(18)
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconBackground: Color
    let iconColor: Color
    let palette: ProfilePalette
    @Binding var isOn: Bool
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBackground)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.text)
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(tint)
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(18)
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    AppSettingsView()
}
