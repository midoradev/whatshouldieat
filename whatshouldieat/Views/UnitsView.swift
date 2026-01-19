import SwiftUI

struct UnitsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(UserPreferences.weightUnitKey) private var storedWeightUnit = WeightUnit.kg.rawValue
    @AppStorage(UserPreferences.heightUnitKey) private var storedHeightUnit = HeightUnit.cm.rawValue
    @AppStorage(UserPreferences.energyUnitKey) private var storedEnergyUnit = EnergyUnit.kcal.rawValue

    @State private var weightUnit: WeightUnit = .kg
    @State private var heightUnit: HeightUnit = .cm
    @State private var energyUnit: EnergyUnit = .kcal
    private let contentWidth: CGFloat = 430

    var body: some View {
        let palette = UnitsPalette(scheme: colorScheme)

        GeometryReader { proxy in
            let layoutWidth = min(contentWidth, proxy.size.width)

            ScrollView {
                centered(width: layoutWidth) {
                    VStack(spacing: 24) {
                        unitPreferencesSection(palette: palette)
                        infoCard(palette: palette)
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
                weightUnit = WeightUnit(rawValue: storedWeightUnit) ?? .kg
                heightUnit = HeightUnit(rawValue: storedHeightUnit) ?? .cm
                energyUnit = EnergyUnit(rawValue: storedEnergyUnit) ?? .kcal
            }
        }
    }

    private func header(palette: UnitsPalette, width: CGFloat) -> some View {
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
                Text("Measurement Units")
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

    private func unitPreferencesSection(palette: UnitsPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Unit Preferences", palette: palette)
            VStack(spacing: 0) {
                unitRow(
                    title: "Weight",
                    icon: "scalemass",
                    selection: $weightUnit,
                    options: WeightUnit.allCases,
                    palette: palette
                )
                divider(palette: palette)
                unitRow(
                    title: "Height",
                    icon: "ruler",
                    selection: $heightUnit,
                    options: HeightUnit.allCases,
                    palette: palette
                )
                divider(palette: palette)
                unitRow(
                    title: "Energy",
                    icon: "flame",
                    selection: $energyUnit,
                    options: EnergyUnit.allCases,
                    palette: palette
                )
            }
            .padding(8)
            .background(palette.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
            )
        }
    }

    private func infoCard(palette: UnitsPalette) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle")
                .foregroundColor(palette.primary)
            Text("Changing these units will update how nutritional information and your profile data are displayed throughout the app.")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(palette.mutedText)
        }
        .padding(16)
        .background(palette.primary.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(palette.primary.opacity(0.15), lineWidth: 1)
        )
    }

    private func decorativeIcons(palette: UnitsPalette) -> some View {
        HStack(spacing: 18) {
            Image(systemName: "fork.knife")
            Image(systemName: "leaf")
            Image(systemName: "takeoutbag.and.cup.and.straw")
            Image(systemName: "carrot")
        }
        .font(.system(size: 28, weight: .medium))
        .foregroundColor(palette.primary.opacity(0.12))
        .padding(.top, 10)
    }

    private func saveBar(palette: UnitsPalette, width: CGFloat) -> some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [palette.background.opacity(0.0), palette.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 16)

            centered(width: width) {
                Button {
                    storedWeightUnit = weightUnit.rawValue
                    storedHeightUnit = heightUnit.rawValue
                    storedEnergyUnit = energyUnit.rawValue
                } label: {
                    Text("Save Changes")
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

    private func unitRow<T: Hashable & CaseIterable & RawRepresentable>(
        title: String,
        icon: String,
        selection: Binding<T>,
        options: T.AllCases,
        palette: UnitsPalette
    ) -> some View where T.RawValue == String {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(palette.segmentBackground)
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(palette.mutedText)
                }
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(palette.text)
            }

            Spacer()

            segmentedControl(selection: selection, options: Array(options), palette: palette)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
    }

    private func segmentedControl<T: Hashable & RawRepresentable>(
        selection: Binding<T>,
        options: [T],
        palette: UnitsPalette
    ) -> some View where T.RawValue == String {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { option in
                Button {
                    selection.wrappedValue = option
                } label: {
                    Text(option.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(selection.wrappedValue == option ? .white : palette.mutedText)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selection.wrappedValue == option ? palette.primary : Color.clear)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(palette.segmentBackground)
        .cornerRadius(10)
    }

    private func divider(palette: UnitsPalette) -> some View {
        Rectangle()
            .fill(palette.border)
            .frame(height: 1)
            .padding(.leading, 8)
    }

    private func sectionHeader(_ title: String, palette: UnitsPalette) -> some View {
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

private struct UnitsPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0x317B81) }
    var background: Color { scheme == .dark ? Color(hex: 0x16191D) : Color(hex: 0xF9FAFA) }
    var card: Color { scheme == .dark ? Color(hex: 0x212529) : .white }
    var text: Color { scheme == .dark ? Color(hex: 0xF1F5F5) : Color(hex: 0x111718) }
    var mutedText: Color { scheme == .dark ? Color(hex: 0x9CA3AF) : Color(hex: 0x6B7280) }
    var border: Color { scheme == .dark ? Color(hex: 0x2B3035) : Color(hex: 0xE5E7EB) }
    var headerBackground: Color { scheme == .dark ? Color(hex: 0x16191D).opacity(0.9) : Color(hex: 0xF9FAFA).opacity(0.9) }
    var segmentBackground: Color { scheme == .dark ? Color(hex: 0x2B3035) : Color(hex: 0xF3F4F6) }
}

#Preview {
    UnitsView()
}
