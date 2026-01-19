import Foundation
import SwiftUI

struct PersonalGoalsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(HealthGoals.currentWeightKey) private var storedCurrentWeight = HealthGoals.defaultCurrentWeight
    @AppStorage(HealthGoals.targetWeightKey) private var storedTargetWeight = HealthGoals.defaultTargetWeight
    @AppStorage(HealthGoals.heightCmKey) private var storedHeightCm = HealthGoals.defaultHeightCm
    @AppStorage(HealthGoals.calorieTargetKey) private var storedCalorieTarget = HealthGoals.defaultCalorieTarget
    @AppStorage(HealthGoals.proteinPercentKey) private var storedProteinPercent = HealthGoals.defaultProteinPercent
    @AppStorage(HealthGoals.carbsPercentKey) private var storedCarbsPercent = HealthGoals.defaultCarbsPercent
    @AppStorage(HealthGoals.fatsPercentKey) private var storedFatsPercent = HealthGoals.defaultFatsPercent
    @AppStorage(UserPreferences.weightUnitKey) private var storedWeightUnit = WeightUnit.kg.rawValue
    @AppStorage(UserPreferences.heightUnitKey) private var storedHeightUnit = HeightUnit.cm.rawValue
    @AppStorage(UserPreferences.energyUnitKey) private var storedEnergyUnit = EnergyUnit.kcal.rawValue

    @State private var currentWeight = HealthGoals.defaultCurrentWeight
    @State private var targetWeight = HealthGoals.defaultTargetWeight
    @State private var heightCm = HealthGoals.defaultHeightCm
    @State private var calorieTarget = HealthGoals.defaultCalorieTarget
    @State private var proteinPercent = HealthGoals.defaultProteinPercent
    @State private var carbsPercent = HealthGoals.defaultCarbsPercent
    @State private var fatsPercent = HealthGoals.defaultFatsPercent
    @State private var showSaveConfirmation = false
    
    private var weightUnit: WeightUnit {
        WeightUnit(rawValue: storedWeightUnit) ?? .kg
    }
    
    private var energyUnit: EnergyUnit {
        EnergyUnit(rawValue: storedEnergyUnit) ?? .kcal
    }

    private var heightUnit: HeightUnit {
        HeightUnit(rawValue: storedHeightUnit) ?? .cm
    }

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 18) {
                bodyMetricsCard(palette: palette)
                calorieTargetCard(palette: palette)
                macroDistributionCard(palette: palette)
                saveButton(palette: palette)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(palette.background.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            header(palette: palette)
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showSaveConfirmation {
                saveConfirmationOverlay(palette: palette)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .onAppear {
            loadStoredGoals()
        }
    }

    private func header(palette: ProfilePalette) -> some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(palette.text)
                    .frame(width: 40, height: 40)
                    .background(palette.primary.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Health Goals")
                .font(.system(size: 20, weight: .bold, design: .rounded))
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
                .foregroundColor(palette.border.opacity(0.4)),
            alignment: .bottom
        )
    }

    private func bodyMetricsCard(palette: ProfilePalette) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Body Metrics")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
                .tracking(1)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                metricField(
                    title: "Current Weight",
                    value: weightBinding($currentWeight),
                    unitLabel: weightUnit.label,
                    accent: palette.text,
                    palette: palette
                )

                metricField(
                    title: "Target Weight",
                    value: weightBinding($targetWeight),
                    unitLabel: weightUnit.label,
                    accent: palette.brandOrange,
                    palette: palette
                )

                metricField(
                    title: "Height",
                    value: heightBinding($heightCm),
                    unitLabel: heightUnit.label,
                    accent: palette.text,
                    palette: palette
                )

                metricDisplay(
                    title: "BMI",
                    value: bmiValue,
                    accent: palette.brandOrange,
                    palette: palette
                )
            }
        }
        .padding(18)
        .background(palette.card)
        .cornerRadius(24)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }

    private func metricField(
        title: String,
        value: Binding<Double>,
        unitLabel: String,
        accent: Color,
        palette: ProfilePalette
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(palette.mutedText)

            HStack(spacing: 6) {
                TextField("", value: value, format: .number.precision(.fractionLength(1)))
                    .keyboardType(.decimalPad)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(accent)
                    .textFieldStyle(.plain)
                Text(unitLabel)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(palette.mutedText)
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(palette.background)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border.opacity(0.4), lineWidth: 1)
            )
        }
    }

    private func metricDisplay(
        title: String,
        value: String,
        accent: Color,
        palette: ProfilePalette
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(palette.mutedText)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(accent)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(palette.background)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(palette.border.opacity(0.4), lineWidth: 1)
        )
    }

    private func calorieTargetCard(palette: ProfilePalette) -> some View {
        let energyBindingValue = energyBinding($calorieTarget)
        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Calorie Target")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(palette.mutedText)
                        .textCase(.uppercase)
                        .tracking(1)
                    Text("Based on active lifestyle")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }

                Spacer()

                HStack(spacing: 6) {
                    TextField("", value: energyBindingValue, format: .number.precision(.fractionLength(0)))
                        .keyboardType(.numberPad)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(palette.brandOrange)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.plain)
                        .frame(width: 60)
                    Text(energyUnit.label)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(palette.brandOrange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(palette.brandOrange.opacity(0.12))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(palette.brandOrange.opacity(0.25), lineWidth: 1)
                )
            }

            Slider(value: energyBindingValue, in: energyRange, step: energyStep)
                .tint(palette.brandOrange)

            HStack {
                Text("\(Int(energyRange.lowerBound))")
                Spacer()
                Text("\(Int(energyRange.upperBound))")
            }
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(palette.mutedText)
        }
        .padding(18)
        .background(palette.card)
        .cornerRadius(24)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }

    private func macroDistributionCard(palette: ProfilePalette) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Macros Distribution")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(palette.mutedText)
                .textCase(.uppercase)
                .tracking(1)

            macroRow(
                title: "Protein",
                percent: proteinPercent,
                grams: macroGrams(percent: proteinPercent, caloriesPerGram: 4),
                color: palette.brandOrange,
                palette: palette
            ) {
                Slider(value: $proteinPercent, in: 0...100, step: 1)
                    .tint(palette.brandOrange)
            }

            macroRow(
                title: "Carbs",
                percent: carbsPercent,
                grams: macroGrams(percent: carbsPercent, caloriesPerGram: 4),
                color: palette.brandTeal,
                palette: palette
            ) {
                Slider(value: $carbsPercent, in: 0...100, step: 1)
                    .tint(palette.brandTeal)
            }

            macroRow(
                title: "Fats",
                percent: fatsPercent,
                grams: macroGrams(percent: fatsPercent, caloriesPerGram: 9),
                color: palette.brandYellow,
                palette: palette
            ) {
                Slider(value: $fatsPercent, in: 0...100, step: 1)
                    .tint(palette.brandYellow)
            }

            HStack {
                Text("Total Distribution")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(palette.mutedText)
                Spacer()
                Text("\(Int(totalPercent))%")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: 0x16A34A))
            }
            .padding(12)
            .background(palette.background)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border.opacity(0.6), lineWidth: 1)
            )
        }
        .padding(18)
        .background(palette.card)
        .cornerRadius(24)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }

    private func macroRow(
        title: String,
        percent: Double,
        grams: Int,
        color: Color,
        palette: ProfilePalette,
        slider: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(palette.text)
                }
                Spacer()
                Text("\(Int(percent))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(palette.text)
                Text("(\(grams)g)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(palette.mutedText)
            }

            slider()
        }
    }

    private func saveButton(palette: ProfilePalette) -> some View {
        Button {
            storedCurrentWeight = currentWeight
            storedTargetWeight = targetWeight
            storedHeightCm = heightCm
            storedCalorieTarget = calorieTarget
            storedProteinPercent = proteinPercent
            storedCarbsPercent = carbsPercent
            storedFatsPercent = fatsPercent
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showSaveConfirmation = true
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "tray.and.arrow.down.fill")
                Text("Save Goals")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(palette.brandOrange)
            .cornerRadius(18)
            .shadow(color: palette.brandOrange.opacity(0.25), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private func macroGrams(percent: Double, caloriesPerGram: Double) -> Int {
        let calories = calorieTarget * percent / 100.0
        return Int(calories / caloriesPerGram)
    }

    private var totalPercent: Double {
        proteinPercent + carbsPercent + fatsPercent
    }

    private func loadStoredGoals() {
        currentWeight = storedCurrentWeight
        targetWeight = storedTargetWeight
        heightCm = storedHeightCm
        calorieTarget = storedCalorieTarget
        proteinPercent = storedProteinPercent
        carbsPercent = storedCarbsPercent
        fatsPercent = storedFatsPercent
    }

    private func weightBinding(_ base: Binding<Double>) -> Binding<Double> {
        Binding(
            get: { weightUnit.displayValue(fromKg: base.wrappedValue) },
            set: { base.wrappedValue = weightUnit.kgValue(from: $0) }
        )
    }
    
    private func energyBinding(_ base: Binding<Double>) -> Binding<Double> {
        Binding(
            get: { energyUnit.displayValue(fromKcal: base.wrappedValue) },
            set: { base.wrappedValue = energyUnit.kcalValue(from: $0) }
        )
    }

    private func heightBinding(_ base: Binding<Double>) -> Binding<Double> {
        Binding(
            get: { heightUnit.displayValue(fromCm: base.wrappedValue) },
            set: { base.wrappedValue = heightUnit.cmValue(from: $0) }
        )
    }
    
    private var energyRange: ClosedRange<Double> {
        let lower = energyUnit.displayValue(fromKcal: 1200)
        let upper = energyUnit.displayValue(fromKcal: 4000)
        return lower...upper
    }
    
    private var energyStep: Double {
        energyUnit.displayValue(fromKcal: 50)
    }

    private var bmiValue: String {
        let heightMeters = heightCm / 100.0
        guard heightMeters > 0 else { return "--" }
        let bmi = currentWeight / (heightMeters * heightMeters)
        return String(format: "%.1f", bmi)
    }

    private func saveConfirmationOverlay(palette: ProfilePalette) -> some View {
        ZStack {
            Color.black.opacity(colorScheme == .dark ? 0.5 : 0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showSaveConfirmation = false
                    }
                }

            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(palette.brandOrange)
                Text("Goals Saved")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Text("Your tracker is updated.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(palette.mutedText)

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showSaveConfirmation = false
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(palette.brandOrange)
                        .cornerRadius(14)
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .frame(maxWidth: 260)
            .background(palette.card)
            .cornerRadius(22)
            .shadow(color: palette.shadow, radius: 16, x: 0, y: 10)
        }
    }
}

#Preview {
    PersonalGoalsView()
}
