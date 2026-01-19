import SwiftUI

struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var searchQuery = ""

    private let actions = SupportAction.sample
    private let faqs = SupportFAQ.sample

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 20) {
                searchBar(palette: palette)
                actionGrid(palette: palette)
                faqSection(palette: palette)
                footer(palette: palette)
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
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.mutedText)
                    .frame(width: 36, height: 36)
                    .background(palette.primary.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Help & Support")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
            Spacer()
            Color.clear.frame(width: 36, height: 36)
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

    private func searchBar(palette: ProfilePalette) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(palette.mutedText)
            TextField("Search for FAQs...", text: $searchQuery)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(palette.card)
        .cornerRadius(16)
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
    }

    private func actionGrid(palette: ProfilePalette) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(actions) { action in
                Button { } label: {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(action.iconBackground)
                                .frame(width: 48, height: 48)
                            Image(systemName: action.icon)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(action.iconColor)
                        }
                        Text(action.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(palette.text)
                            .multilineTextAlignment(.center)
                        if let subtitle = action.subtitle {
                            Text(subtitle)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(palette.mutedText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(palette.card)
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(palette.border.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func faqSection(palette: ProfilePalette) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Frequently Asked")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(palette.mutedText)
                    .textCase(.uppercase)
                    .tracking(1)
                Spacer()
                Button("See All") { }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(palette.brandOrange)
            }

            VStack(spacing: 10) {
                ForEach(faqs) { faq in
                    Button { } label: {
                        HStack {
                            Text(faq.title)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(palette.text)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(palette.mutedText)
                        }
                        .padding(12)
                        .background(palette.card)
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(palette.border.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func footer(palette: ProfilePalette) -> some View {
        VStack(spacing: 6) {
            Text("Version 2.4.1 (Build 882)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(palette.mutedText)
            Text("Copyright 2024 What Should I Eat")
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(palette.mutedText.opacity(0.6))
                .textCase(.uppercase)
        }
        .padding(.top, 12)
    }
}

private struct SupportAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let icon: String
    let iconBackground: Color
    let iconColor: Color

    static let sample: [SupportAction] = [
        SupportAction(
            title: "Live Chat",
            subtitle: "Reply in 5 mins",
            icon: "message",
            iconBackground: Color(hex: 0xFFF7ED),
            iconColor: Color(hex: 0xF97316)
        ),
        SupportAction(
            title: "Email Us",
            subtitle: "Reply in 24 hours",
            icon: "envelope",
            iconBackground: Color(hex: 0xDBEAFE),
            iconColor: Color(hex: 0x2563EB)
        ),
        SupportAction(
            title: "Report a Bug",
            subtitle: nil,
            icon: "ladybug",
            iconBackground: Color(hex: 0xFEE2E2),
            iconColor: Color(hex: 0xDC2626)
        ),
        SupportAction(
            title: "Request Feature",
            subtitle: nil,
            icon: "lightbulb",
            iconBackground: Color(hex: 0xDCFCE7),
            iconColor: Color(hex: 0x16A34A)
        ),
    ]
}

private struct SupportFAQ: Identifiable {
    let id = UUID()
    let title: String

    static let sample: [SupportFAQ] = [
        SupportFAQ(title: "How do I track manual calories?"),
        SupportFAQ(title: "Can I change my diet preference?"),
        SupportFAQ(title: "Exporting my eating history"),
        SupportFAQ(title: "Understanding macro targets"),
    ]
}

#Preview {
    SupportView()
}
