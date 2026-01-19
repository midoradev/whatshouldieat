import SwiftUI

struct EatingHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    private let historyDays = HistoryDay.sample

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 24) {
                ForEach(historyDays) { day in
                    HistoryDaySection(day: day, palette: palette)
                }
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
        HStack {
            HStack(spacing: 8) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(palette.brandOrange)
                }
                Text("Eating History")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
            }
            Spacer()
            Button { } label: {
                Image(systemName: "calendar")
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
}

private struct HistoryDaySection: View {
    let day: HistoryDay
    let palette: ProfilePalette

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(palette.text)
                    Text(day.subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }
                Spacer()
                HStack(spacing: 8) {
                    ProgressBar(progress: day.progress, color: day.progressColor, palette: palette)
                        .frame(width: 80)
                    Text("\(Int(day.progress * 100))%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(day.progressColor)
                }
            }
            .padding(12)
            .background(palette.card.opacity(day.isMuted ? 0.6 : 1.0))
            .cornerRadius(18)
            .shadow(color: palette.shadow.opacity(day.isMuted ? 0.4 : 1.0), radius: 10, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(palette.border.opacity(0.3), lineWidth: 1)
            )

            TimelineStack(entries: day.entries, palette: palette)
                .opacity(day.isMuted ? 0.8 : 1.0)
        }
    }
}

private struct TimelineStack: View {
    let entries: [HistoryEntry]
    let palette: ProfilePalette

    var body: some View {
        VStack(spacing: 12) {
            ForEach(entries) { entry in
                HistoryEntryRow(entry: entry, palette: palette)
            }
        }
        .padding(.leading, 24)
        .overlay(alignment: .leading) {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 1)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
                    .foregroundColor(palette.border)
                    .frame(width: 2, height: proxy.size.height)
                    .offset(x: 8)
            }
        }
    }
}

private struct HistoryEntryRow: View {
    let entry: HistoryEntry
    let palette: ProfilePalette

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(entry.iconBackground)
                        .frame(width: 48, height: 48)
                    Image(systemName: entry.icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(entry.iconColor)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(entry.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(palette.text)
                        Spacer()
                        Text(entry.calories)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(palette.text)
                    }

                    Text(entry.detail)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)

                    HStack(spacing: 12) {
                        ForEach(entry.macros, id: \.self) { macro in
                            Text(macro)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(palette.mutedText)
                        }
                    }
                }
            }
            .padding(12)
            .background(palette.card)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(palette.border.opacity(0.3), lineWidth: 1)
            )

            Circle()
                .fill(entry.markerColor)
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(palette.background, lineWidth: 3)
                )
                .offset(x: -10)
        }
    }
}

private struct ProgressBar: View {
    let progress: Double
    let color: Color
    let palette: ProfilePalette

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(palette.background.opacity(0.6))
                Capsule()
                    .fill(color)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 6)
    }
}

private struct HistoryDay: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let progress: Double
    let progressColor: Color
    let entries: [HistoryEntry]
    let isMuted: Bool

    static let sample: [HistoryDay] = [
        HistoryDay(
            title: "Today, Oct 24",
            subtitle: "Total: 1840 / 2100 kcal",
            progress: 0.87,
            progressColor: Color(hex: 0xF97316),
            entries: [
                HistoryEntry(
                    title: "Breakfast",
                    detail: "Greek Yogurt with Berries",
                    calories: "420 kcal",
                    macros: ["P: 24g", "C: 32g", "F: 12g"],
                    icon: "sunrise",
                    iconBackground: Color(hex: 0xFFF7ED),
                    iconColor: Color(hex: 0xF97316),
                    markerColor: Color(hex: 0xF97316)
                ),
                HistoryEntry(
                    title: "Lunch",
                    detail: "Teriyaki Salmon Bowl",
                    calories: "680 kcal",
                    macros: ["P: 42g", "C: 58g", "F: 22g"],
                    icon: "sun.max",
                    iconBackground: Color(hex: 0xDBEAFE),
                    iconColor: Color(hex: 0x2563EB),
                    markerColor: Color(hex: 0xF97316)
                ),
                HistoryEntry(
                    title: "Snack",
                    detail: "Almonds and Green Tea",
                    calories: "150 kcal",
                    macros: ["P: 6g", "C: 4g", "F: 14g"],
                    icon: "leaf",
                    iconBackground: Color(hex: 0xE0F2F1),
                    iconColor: Color(hex: 0x0F766E),
                    markerColor: Color(hex: 0xF97316)
                ),
            ],
            isMuted: false
        ),
        HistoryDay(
            title: "Yesterday, Oct 23",
            subtitle: "Total: 2050 / 2100 kcal",
            progress: 0.97,
            progressColor: Color(hex: 0x22C55E),
            entries: [
                HistoryEntry(
                    title: "Dinner",
                    detail: "Mexican Chicken Fajitas",
                    calories: "750 kcal",
                    macros: ["P: 45g", "C: 62g", "F: 28g"],
                    icon: "moon.stars",
                    iconBackground: Color(hex: 0xEDE9FE),
                    iconColor: Color(hex: 0x7C3AED),
                    markerColor: Color(hex: 0x8E7357)
                ),
            ],
            isMuted: true
        ),
    ]
}

private struct HistoryEntry: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let calories: String
    let macros: [String]
    let icon: String
    let iconBackground: Color
    let iconColor: Color
    let markerColor: Color
}

#Preview {
    EatingHistoryView()
}
