import SwiftUI

struct TrackView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let progressValue = 1240.0
    @AppStorage(HealthGoals.calorieTargetKey) private var storedCalorieTarget = HealthGoals.defaultCalorieTarget
    @AppStorage(HealthGoals.proteinPercentKey) private var storedProteinPercent = HealthGoals.defaultProteinPercent
    @AppStorage(HealthGoals.carbsPercentKey) private var storedCarbsPercent = HealthGoals.defaultCarbsPercent
    @AppStorage(HealthGoals.fatsPercentKey) private var storedFatsPercent = HealthGoals.defaultFatsPercent
    @AppStorage(HealthGoals.currentWeightKey) private var storedCurrentWeight = HealthGoals.defaultCurrentWeight
    @AppStorage(HealthGoals.targetWeightKey) private var storedTargetWeight = HealthGoals.defaultTargetWeight
    @AppStorage(HealthGoals.heightCmKey) private var storedHeightCm = HealthGoals.defaultHeightCm
    @AppStorage(UserPreferences.energyUnitKey) private var storedEnergyUnit = EnergyUnit.kcal.rawValue
    @AppStorage(UserPreferences.weightUnitKey) private var storedWeightUnit = WeightUnit.kg.rawValue
    @AppStorage(UserPreferences.heightUnitKey) private var storedHeightUnit = HeightUnit.cm.rawValue

    private var progressGoal: Double {
        max(storedCalorieTarget, 1)
    }
    
    private var energyUnit: EnergyUnit {
        EnergyUnit(rawValue: storedEnergyUnit) ?? .kcal
    }

    private var weightUnit: WeightUnit {
        WeightUnit(rawValue: storedWeightUnit) ?? .kg
    }

    private var heightUnit: HeightUnit {
        HeightUnit(rawValue: storedHeightUnit) ?? .cm
    }

    private let mealSections = MealSection.sample

    var body: some View {
        let palette = TrackPalette(scheme: colorScheme)

        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    progressRing(palette: palette)
                    bodyMetricsSection(palette: palette)
                    macroSummary(palette: palette)
                    mealsSection(palette: palette)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
            }
            .background(palette.background.ignoresSafeArea())
            .safeAreaInset(edge: .top, spacing: 0) {
                header(palette: palette)
            }

            addMealButton(palette: palette)
                .padding(.trailing, 20)
                .padding(.bottom, 80)
        }
    }

    private func header(palette: TrackPalette) -> some View {
        HStack {
            Button { } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(palette.text)
                    .frame(width: 40, height: 40)
                    .background(palette.card)
                    .clipShape(Circle())
                    .shadow(color: palette.shadow, radius: 8, x: 0, y: 4)
            }
            Spacer()
            Text("Nutrition Tracker")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
            Spacer()
            Button { } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(palette.primary)
                    .frame(width: 40, height: 40)
                    .background(palette.card)
                    .clipShape(Circle())
                    .shadow(color: palette.shadow, radius: 8, x: 0, y: 4)
            }
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

    private func progressRing(palette: TrackPalette) -> some View {
        let progress = CGFloat(progressValue / progressGoal)

        return ZStack {
            Circle()
                .stroke(palette.border, lineWidth: 12)
                .frame(width: 190, height: 190)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(palette.primary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 190, height: 190)

            VStack(spacing: 4) {
                Text("\(energyDisplayValue(progressValue))")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(palette.text)
                Text("Left of \(energyDisplayValue(progressGoal)) \(energyUnit.label)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(palette.mutedText)
                    .textCase(.uppercase)
                    .tracking(1)
            }
        }
        .padding(.top, 10)
    }

    private func macroSummary(palette: TrackPalette) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(macroCards) { card in
                MacroCardView(card: card, palette: palette)
            }
        }
    }

    private func bodyMetricsSection(palette: TrackPalette) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Body Metrics")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
                .tracking(1)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                metricTile(
                    title: "Current Weight",
                    value: weightDisplayValue(storedCurrentWeight),
                    unit: weightUnit.label,
                    accent: palette.text,
                    palette: palette
                )

                metricTile(
                    title: "Target Weight",
                    value: weightDisplayValue(storedTargetWeight),
                    unit: weightUnit.label,
                    accent: palette.primary,
                    palette: palette
                )

                metricTile(
                    title: "Height",
                    value: heightDisplayValue(storedHeightCm),
                    unit: heightUnit == .cm ? heightUnit.label : nil,
                    accent: palette.text,
                    palette: palette
                )

                metricTile(
                    title: "BMI",
                    value: bmiValue,
                    unit: nil,
                    accent: palette.primary,
                    palette: palette
                )
            }
        }
        .padding(16)
        .background(palette.card)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(palette.border.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
    }

    private func metricTile(
        title: String,
        value: String,
        unit: String?,
        accent: Color,
        palette: TrackPalette
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(accent)
                if let unit {
                    Text(unit)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(palette.mutedText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(palette.background)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(palette.border.opacity(0.5), lineWidth: 1)
        )
    }

    private func mealsSection(palette: TrackPalette) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Meals")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)

            ForEach(mealSections) { section in
                MealSectionView(section: section, palette: palette, energyUnit: energyUnit)
            }
        }
    }

    private func addMealButton(palette: TrackPalette) -> some View {
        Button { } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(palette.text)
                .frame(width: 56, height: 56)
                .background(palette.primary)
                .clipShape(Circle())
                .shadow(color: palette.primary.opacity(0.5), radius: 16, x: 0, y: 8)
        }
    }

    private func energyDisplayValue(_ kcal: Double) -> Int {
        Int(energyUnit.displayValue(fromKcal: kcal))
    }

    private func weightDisplayValue(_ kg: Double) -> String {
        String(format: "%.1f", weightUnit.displayValue(fromKg: kg))
    }

    private func heightDisplayValue(_ cm: Double) -> String {
        switch heightUnit {
        case .cm:
            return String(format: "%.0f", cm)
        case .ftIn:
            let totalInches = Int(round(heightUnit.displayValue(fromCm: cm)))
            let feet = totalInches / 12
            let inches = totalInches % 12
            return "\(feet)'\(inches)\""
        }
    }

    private var bmiValue: String {
        let heightMeters = storedHeightCm / 100.0
        guard heightMeters > 0 else { return "--" }
        let bmi = storedCurrentWeight / (heightMeters * heightMeters)
        return String(format: "%.1f", bmi)
    }

    private var macroCards: [MacroCard] {
        let proteinTarget = macroTarget(percentage: storedProteinPercent, caloriesPerGram: 4)
        let carbsTarget = macroTarget(percentage: storedCarbsPercent, caloriesPerGram: 4)
        let fatsTarget = macroTarget(percentage: storedFatsPercent, caloriesPerGram: 9)

        let proteinCurrent = 45.0
        let carbsCurrent = 120.0
        let fatsCurrent = 32.0

        return [
            MacroCard(
                title: "Protein",
                value: "\(Int(proteinCurrent)) / \(proteinTarget)g",
                progress: macroProgress(current: proteinCurrent, target: Double(proteinTarget)),
                progressColor: Color(hex: 0xF0D9C2)
            ),
            MacroCard(
                title: "Carbs",
                value: "\(Int(carbsCurrent)) / \(carbsTarget)g",
                progress: macroProgress(current: carbsCurrent, target: Double(carbsTarget)),
                progressColor: Color(hex: 0xE0F2F1)
            ),
            MacroCard(
                title: "Fats",
                value: "\(Int(fatsCurrent)) / \(fatsTarget)g",
                progress: macroProgress(current: fatsCurrent, target: Double(fatsTarget)),
                progressColor: Color(hex: 0xF3E8FF)
            ),
        ]
    }

    private func macroTarget(percentage: Double, caloriesPerGram: Double) -> Int {
        let calories = storedCalorieTarget * percentage / 100.0
        return max(Int(calories / caloriesPerGram), 1)
    }

    private func macroProgress(current: Double, target: Double) -> CGFloat {
        guard target > 0 else { return 0 }
        return CGFloat(min(current / target, 1))
    }
}

private struct MacroCardView: View {
    let card: MacroCard
    let palette: TrackPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(card.title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
            Text(card.value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(palette.text)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(palette.progressTrack)
                    .frame(height: 6)
                Capsule()
                    .fill(card.progressColor)
                    .frame(width: 60 * card.progress, height: 6)
            }
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(16)
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
    }
}

private struct MealSectionView: View {
    let section: MealSection
    let palette: TrackPalette
    let energyUnit: EnergyUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(section.title, systemImage: section.icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.mutedText)
                Spacer()
                Text(summaryText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(palette.mutedText)
            }

            if section.meals.isEmpty {
                Button { } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add \(section.title)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(palette.mutedText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(palette.border)
                    )
                }
                .buttonStyle(.plain)
            } else {
                VStack(spacing: 12) {
                    ForEach(section.meals) { meal in
                        MealRow(meal: meal, palette: palette, energyUnit: energyUnit)
                    }
                }
            }
        }
        .padding(.bottom, 4)
    }

    private var summaryText: String {
        if let calories = section.summaryCalories {
            return "\(Int(energyUnit.displayValue(fromKcal: calories))) \(energyUnit.label)"
        }
        return "Not tracked yet"
    }
}

private struct MealRow: View {
    let meal: MealEntry
    let palette: TrackPalette
    let energyUnit: EnergyUnit

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: meal.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(palette.card)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(palette.text)
                Text(detailText)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Spacer()

            HStack(spacing: 4) {
                Button { } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(palette.mutedText)
                        .frame(width: 32, height: 32)
                }
                Button { } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.red.opacity(0.8))
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(palette.border.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
    }

    private var detailText: String {
        let calories = Int(energyUnit.displayValue(fromKcal: meal.calories))
        return "\(calories) \(energyUnit.label) - \(meal.serving)"
    }
}

private struct MacroCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let progress: CGFloat
    let progressColor: Color
}

private struct MealSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let summaryCalories: Double?
    let meals: [MealEntry]

    static let sample: [MealSection] = [
        MealSection(
            title: "Breakfast",
            icon: "sun.max",
            summaryCalories: 420,
            meals: [
                MealEntry(
                    title: "Classic Shakshuka",
                    calories: 340,
                    serving: "1 serving",
                    imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDSVVXxICOiZ38kQOA0B4akkJnzv0-Af0G1aq0oR8wywehTQA5JB_Rj6KdD7KDyZdH5VGK2aRi_lp4C7uyWDeHGLJ1I0yP33GbTJdo2Y8ITpoyPE5b6R5QASFW_uuL3Y2Di3g4SSU9OB6IJY8Wv0fp_zNEuKNrjO0Ep3B-d8lCZ373bj-8CV8Oi-N-Z2ncTUk5S1Ul2vEz5OMt20SFbI6svUHoYmnrRIPq4vHaOTIlfYUq7mSm_0zLjsXou-OVvXXxe1bAOzpn0bzrG")!
                ),
            ]
        ),
        MealSection(
            title: "Lunch",
            icon: "fork.knife",
            summaryCalories: 820,
            meals: [
                MealEntry(
                    title: "Tonkotsu Ramen",
                    calories: 520,
                    serving: "1 bowl",
                    imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDtHUASTBrjqY29nrW23qdWm8F7OcqX5pqARDJSGtbGcigbmzrEPX1qjepE0-1IT2_wpEg4pY_KWnqXbbk_kuHNgieYQUqvsiPrHr_EThIjCzKEnPaPgVVqXWh_MW6TlcXXPltAUkwUntaqG9Ula5oE5CJIZIYbAbEycXuaWSd6DH9PprTcfokKLA_RcpgrPh8ytGOtC_qcVk1Com44e8TFImA6IQJ4CSuH162G8ZWx_vpHK2ZUPE7FS8FLA8eI_XZcxgMshVVWtA6B")!
                ),
            ]
        ),
        MealSection(
            title: "Dinner",
            icon: "moon.stars",
            summaryCalories: nil,
            meals: []
        ),
    ]
}

private struct MealEntry: Identifiable {
    let id = UUID()
    let title: String
    let calories: Double
    let serving: String
    let imageURL: URL
}

private struct TrackPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0xF0D9C2) }
    var accentMint: Color { Color(hex: 0xE0F2F1) }
    var accentLavender: Color { Color(hex: 0xF3E8FF) }

    var background: Color {
        scheme == .dark ? Color(hex: 0x1F1913) : Color(hex: 0xF8F7F6)
    }

    var card: Color {
        scheme == .dark ? Color(hex: 0x2A221A) : .white
    }

    var text: Color {
        scheme == .dark ? Color(hex: 0xFBFAF9) : Color(hex: 0x191410)
    }

    var mutedText: Color {
        scheme == .dark ? Color(hex: 0xA68C71) : Color(hex: 0x8E7357)
    }

    var border: Color {
        scheme == .dark ? Color(hex: 0x3A3026) : Color(hex: 0xE4DBD3)
    }

    var headerBackground: Color {
        scheme == .dark ? Color(hex: 0x1F1913).opacity(0.92) : Color(hex: 0xF8F7F6).opacity(0.92)
    }

    var progressTrack: Color {
        scheme == .dark ? Color.white.opacity(0.08) : Color(hex: 0xEFE8E2)
    }

    var shadow: Color {
        Color(hex: 0x8E7357).opacity(0.12)
    }
}

#Preview {
    TrackView()
}
