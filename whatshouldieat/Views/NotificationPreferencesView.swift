import SwiftUI

struct NotificationPreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var allowPush = true
    @State private var breakfastReminder = true
    @State private var lunchReminder = true
    @State private var dinnerReminder = true
    @State private var dailySummary = false
    @State private var newCuisines = true
    @State private var socialActivity = true

    var body: some View {
        let palette = NotificationPalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 22) {
                masterToggle(palette: palette)
                mealRemindersSection(palette: palette)
                insightsSection(palette: palette)
                communitySection(palette: palette)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
        .background(palette.background.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            header(palette: palette)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            saveBar(palette: palette)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func header(palette: NotificationPalette) -> some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(palette.text)
                    .frame(width: 40, height: 40)
                    .background(palette.card)
                    .clipShape(Circle())
            }
            Spacer()
            Text("Notification Preferences")
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

    private func masterToggle(palette: NotificationPalette) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(palette.primary)
                    .frame(width: 44, height: 44)
                Image(systemName: "bell.badge.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Allow Push Notifications")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(palette.text)
                Text("Enable all app alerts")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            Toggle("", isOn: $allowPush)
                .labelsHidden()
                .tint(palette.primary)
        }
        .padding(16)
        .background(palette.primary.opacity(0.12))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(palette.primary.opacity(0.2), lineWidth: 1)
        )
    }

    private func mealRemindersSection(palette: NotificationPalette) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Meal Reminders", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "cup.and.saucer",
                    iconColor: palette.primary,
                    title: "Breakfast",
                    subtitle: "Morning planning alerts",
                    isOn: $breakfastReminder,
                    palette: palette
                )
                Divider().background(palette.border)
                toggleRow(
                    icon: "sun.max",
                    iconColor: Color(hex: 0x87CACA),
                    title: "Lunch",
                    subtitle: "Midday meal suggestions",
                    isOn: $lunchReminder,
                    palette: palette
                )
                Divider().background(palette.border)
                toggleRow(
                    icon: "moon.stars",
                    iconColor: Color(hex: 0x5D57A3),
                    title: "Dinner",
                    subtitle: "Evening cooking reminders",
                    isOn: $dinnerReminder,
                    palette: palette
                )
            }
            .background(palette.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func insightsSection(palette: NotificationPalette) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Insights and Updates", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "doc.text",
                    iconColor: palette.primary,
                    title: "Daily Summary",
                    subtitle: "End of day nutritional report",
                    isOn: $dailySummary,
                    palette: palette
                )
                Divider().background(palette.border)
                toggleRow(
                    icon: "globe",
                    iconColor: Color(hex: 0x87CACA),
                    title: "New Cuisines",
                    subtitle: "Alerts for new regional recipes",
                    isOn: $newCuisines,
                    palette: palette
                )
            }
            .background(palette.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func communitySection(palette: NotificationPalette) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Community", palette: palette)
            VStack(spacing: 0) {
                toggleRow(
                    icon: "person.2",
                    iconColor: palette.primary,
                    title: "Social Activity",
                    subtitle: "Likes, comments, and shared meals",
                    isOn: $socialActivity,
                    palette: palette
                )
            }
            .background(palette.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func saveBar(palette: NotificationPalette) -> some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [palette.background.opacity(0.0), palette.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 16)

            Button { } label: {
                HStack(spacing: 8) {
                    Text("Save Preferences")
                        .font(.system(size: 16, weight: .bold))
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(palette.primary)
                .cornerRadius(16)
                .shadow(color: palette.primary.opacity(0.3), radius: 12, x: 0, y: 8)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .background(palette.background)
        }
    }

    private func toggleRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>,
        palette: NotificationPalette
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(palette.text)
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
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

    private func sectionHeader(_ title: String, palette: NotificationPalette) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(palette.text)
            .textCase(.uppercase)
            .tracking(1)
            .padding(.leading, 4)
    }
}

private struct NotificationPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0xEE8C2B) }

    var background: Color {
        scheme == .dark ? Color(hex: 0x2C2621) : Color(hex: 0xFDF9F7)
    }

    var card: Color {
        scheme == .dark ? Color(hex: 0x342D27) : .white
    }

    var text: Color {
        scheme == .dark ? Color(hex: 0xF3EDE7) : Color(hex: 0x1B140D)
    }

    var mutedText: Color {
        scheme == .dark ? Color(hex: 0xBCA084) : Color(hex: 0x9A734C)
    }

    var border: Color {
        scheme == .dark ? Color(hex: 0x3D352E) : Color(hex: 0xF3EDE7)
    }

    var headerBackground: Color {
        scheme == .dark ? Color(hex: 0x2C2621).opacity(0.9) : Color(hex: 0xFDF9F7).opacity(0.9)
    }
}

#Preview {
    NotificationPreferencesView()
}
