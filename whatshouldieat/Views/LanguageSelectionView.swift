import SwiftUI

struct LanguageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(UserPreferences.languageKey) private var storedLanguageCode = UserPreferences.defaultLanguageCode
    @State private var selectedLanguageCode = UserPreferences.defaultLanguageCode
    private let contentWidth: CGFloat = 430

    var body: some View {
        let palette = LanguageSelectionPalette(scheme: colorScheme)
        let currentLanguage = UserPreferences.languageOption(for: storedLanguageCode)

        GeometryReader { proxy in
            let layoutWidth = min(contentWidth, proxy.size.width)

            ScrollView {
                centered(width: layoutWidth) {
                    VStack(spacing: 24) {
                        currentLanguageSection(current: currentLanguage, palette: palette)
                        chooseLanguageSection(palette: palette)
                        decorativeIcons(palette: palette)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 80)
                }
            }
            .background(palette.background.ignoresSafeArea())
            .safeAreaInset(edge: .top, spacing: 0) {
                header(palette: palette, width: layoutWidth)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                saveBar(palette: palette, width: layoutWidth)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                selectedLanguageCode = storedLanguageCode
            }
        }
    }

    private func header(palette: LanguageSelectionPalette, width: CGFloat) -> some View {
        centered(width: width) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(palette.primary)
                        .frame(width: 40, height: 40)
                        .background(palette.primary.opacity(0.12))
                        .clipShape(Circle())
                }
                Spacer()
                Text("App Language")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border),
            alignment: .bottom
        )
    }

    private func currentLanguageSection(current: LanguageOption, palette: LanguageSelectionPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Current Language", palette: palette)
            HStack(spacing: 12) {
                languageBadge(text: current.shortLabel, palette: palette)
                VStack(alignment: .leading, spacing: 4) {
                    Text(current.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(palette.text)
                    Text(current.subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(palette.primary)
            }
            .padding(16)
            .background(palette.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func chooseLanguageSection(palette: LanguageSelectionPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Choose Language", palette: palette)
            VStack(spacing: 0) {
                ForEach(UserPreferences.supportedLanguages) { language in
                    Button {
                        selectedLanguageCode = language.code
                    } label: {
                        HStack(spacing: 12) {
                            languageBadge(text: language.shortLabel, palette: palette)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(language.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(palette.text)
                                Text(language.subtitle)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(palette.mutedText)
                            }
                            Spacer()
                            Image(systemName: selectedLanguageCode == language.code ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedLanguageCode == language.code ? palette.primary : palette.border)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(palette.card)
                    }
                    .buttonStyle(.plain)

                    if language.id != UserPreferences.supportedLanguages.last?.id {
                        Divider()
                            .background(palette.border.opacity(0.4))
                    }
                }
            }
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )

            Text("Updating the language will restart the app to apply changes.")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(palette.mutedText)
                .padding(.horizontal, 4)
                .padding(.top, 4)
        }
    }

    private func languageBadge(text: String, palette: LanguageSelectionPalette) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(palette.text)
            .frame(width: 36, height: 36)
            .background(palette.badgeBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(palette.border.opacity(0.7), lineWidth: 1)
            )
    }

    private func decorativeIcons(palette: LanguageSelectionPalette) -> some View {
        HStack(spacing: 20) {
            Image(systemName: "character.bubble")
            Image(systemName: "globe")
            Image(systemName: "textformat")
        }
        .font(.system(size: 28, weight: .medium))
        .foregroundColor(palette.primary.opacity(0.1))
        .padding(.top, 8)
    }

    private func saveBar(palette: LanguageSelectionPalette, width: CGFloat) -> some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [palette.background.opacity(0.0), palette.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 16)

            centered(width: width) {
                Button {
                    storedLanguageCode = selectedLanguageCode
                } label: {
                    Text("Save Language")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(palette.primary)
                        .cornerRadius(16)
                        .shadow(color: palette.primary.opacity(0.25), radius: 12, x: 0, y: 8)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(palette.background)
        }
    }

    private func sectionHeader(_ title: String, palette: LanguageSelectionPalette) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(palette.primary)
            .textCase(.uppercase)
            .tracking(1)
            .padding(.leading, 4)
    }

    private func centered<Content: View>(width: CGFloat, @ViewBuilder _ content: () -> Content) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            content()
                .frame(width: width)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LanguageSelectionPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0x317B81) }
    var background: Color { scheme == .dark ? Color(hex: 0x16191D) : Color(hex: 0xF9FAFA) }
    var card: Color { scheme == .dark ? Color(hex: 0x212529) : .white }
    var text: Color { scheme == .dark ? Color(hex: 0xF1F5F5) : Color(hex: 0x111718) }
    var mutedText: Color { scheme == .dark ? Color(hex: 0x9CA3AF) : Color(hex: 0x6B7280) }
    var border: Color { scheme == .dark ? Color(hex: 0x2B3035) : Color(hex: 0xE5E7EB) }
    var headerBackground: Color { scheme == .dark ? Color(hex: 0x16191D).opacity(0.9) : Color(hex: 0xF9FAFA).opacity(0.9) }
    var badgeBackground: Color { scheme == .dark ? Color.white.opacity(0.06) : Color(hex: 0xF3F4F6) }
}

#Preview {
    LanguageSelectionView()
}
