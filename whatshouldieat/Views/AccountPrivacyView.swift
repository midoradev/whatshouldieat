import SwiftUI

struct AccountPrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var privateProfileEnabled = true
    @State private var appleHealthEnabled = true
    @State private var fitbitEnabled = false
    @State private var adPersonalizationEnabled = true

    var body: some View {
        let palette = PrivacyPalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 24) {
                profileVisibilitySection(palette: palette)
                connectedAppsSection(palette: palette)
                advertisingSection(palette: palette)
                accountControlSection(palette: palette)
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

    private func header(palette: PrivacyPalette) -> some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(palette.text)
                    .frame(width: 40, height: 40)
                    .background(palette.surface.opacity(0.7))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Privacy Settings")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border),
            alignment: .bottom
        )
    }

    private func profileVisibilitySection(palette: PrivacyPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Profile Visibility", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "lock",
                    title: "Private Profile",
                    subtitle: "Hide your meal history and preferences from friends and followers.",
                    isOn: $privateProfileEnabled,
                    palette: palette
                )
            }
            .background(palette.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func connectedAppsSection(palette: PrivacyPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Connected Apps", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "heart",
                    title: "Apple Health",
                    subtitle: "Sync nutritional data and activity.",
                    isOn: $appleHealthEnabled,
                    palette: palette
                )
                Divider().background(palette.border)
                toggleRow(
                    icon: "antenna.radiowaves.left.and.right",
                    title: "Fitbit",
                    subtitle: "Manage calorie tracking sync.",
                    isOn: $fitbitEnabled,
                    palette: palette
                )
            }
            .background(palette.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func advertisingSection(palette: PrivacyPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Advertising", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "cursorarrow.click",
                    title: "Ad Personalization",
                    subtitle: "See relevant meal suggestions based on your search activity.",
                    isOn: $adPersonalizationEnabled,
                    palette: palette
                )
            }
            .background(palette.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func accountControlSection(palette: PrivacyPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account Control", palette: palette)
            VStack(spacing: 0) {
                Button { } label: {
                    HStack {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(palette.mutedText)
                            Text("Download My Data")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(palette.text)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(palette.mutedText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                Divider()
                    .background(palette.border)
                    .padding(.leading, 46)

                Button { } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "trash")
                        Text("Delete Account")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(palette.danger)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
            .background(palette.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )

            Text("Deleting your account will permanently erase your meal logs, preference profile, and connected app associations. This action cannot be undone.")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(palette.mutedText)
                .padding(.horizontal, 4)
        }
    }

    private func toggleRow(
        icon: String,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>,
        palette: PrivacyPalette
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(palette.primary.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(palette.primary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(palette.text)
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(palette.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func sectionHeader(_ title: String, palette: PrivacyPalette) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(palette.mutedText)
            .textCase(.uppercase)
            .tracking(1)
            .padding(.leading, 4)
    }
}

private struct PrivacyPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0x1FADAD) }
    var danger: Color { Color(hex: 0xFF3B30) }

    var background: Color {
        scheme == .dark ? Color(hex: 0x121212) : Color(hex: 0xF8FBFB)
    }

    var surface: Color {
        scheme == .dark ? Color(hex: 0x1E1E1E) : .white
    }

    var text: Color {
        scheme == .dark ? Color(hex: 0xF5F5F5) : Color(hex: 0x0F1A1A)
    }

    var mutedText: Color {
        scheme == .dark ? Color(hex: 0x9BA3A3) : Color(hex: 0x539393)
    }

    var border: Color {
        scheme == .dark ? Color(hex: 0x2E2E2E) : Color(hex: 0xE5ECEC)
    }

    var headerBackground: Color {
        scheme == .dark ? Color(hex: 0x121212).opacity(0.9) : Color(hex: 0xF8FBFB).opacity(0.9)
    }
}

#Preview {
    AccountPrivacyView()
}
