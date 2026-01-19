import Foundation

enum HealthGoals {
    static let currentWeightKey = "healthGoals.currentWeight"
    static let targetWeightKey = "healthGoals.targetWeight"
    static let heightCmKey = "healthGoals.heightCm"
    static let calorieTargetKey = "healthGoals.calorieTarget"
    static let proteinPercentKey = "healthGoals.proteinPercent"
    static let carbsPercentKey = "healthGoals.carbsPercent"
    static let fatsPercentKey = "healthGoals.fatsPercent"

    static let defaultCurrentWeight: Double = 78.5
    static let defaultTargetWeight: Double = 72.0
    static let defaultHeightCm: Double = 172.0
    static let defaultCalorieTarget: Double = 2450
    static let defaultProteinPercent: Double = 30
    static let defaultCarbsPercent: Double = 45
    static let defaultFatsPercent: Double = 25
}
