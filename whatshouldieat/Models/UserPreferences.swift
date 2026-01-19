import Foundation

enum UserPreferences {
    static let languageKey = "preferences.language"
    static let weightUnitKey = "preferences.units.weight"
    static let heightUnitKey = "preferences.units.height"
    static let energyUnitKey = "preferences.units.energy"

    static let defaultLanguageCode = "en-US"

    static let supportedLanguages: [LanguageOption] = [
        LanguageOption(code: "en-US", title: "English (United States)", subtitle: "English (United States)", shortLabel: "EN"),
        LanguageOption(code: "vi-VN", title: "Vietnamese", subtitle: "Vietnamese", shortLabel: "VI"),
    ]

    static func languageOption(for code: String) -> LanguageOption {
        supportedLanguages.first { $0.code == code } ?? supportedLanguages[0]
    }
}

struct LanguageOption: Identifiable, Hashable {
    let code: String
    let title: String
    let subtitle: String
    let shortLabel: String

    var id: String { code }
}

enum WeightUnit: String, CaseIterable {
    case kg
    case lb

    var label: String { rawValue }

    func displayValue(fromKg value: Double) -> Double {
        switch self {
        case .kg:
            return value
        case .lb:
            return value * 2.20462
        }
    }

    func kgValue(from value: Double) -> Double {
        switch self {
        case .kg:
            return value
        case .lb:
            return value / 2.20462
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case cm
    case ftIn = "ft/in"

    var label: String { rawValue }

    func displayValue(fromCm value: Double) -> Double {
        switch self {
        case .cm:
            return value
        case .ftIn:
            return value / 2.54
        }
    }

    func cmValue(from value: Double) -> Double {
        switch self {
        case .cm:
            return value
        case .ftIn:
            return value * 2.54
        }
    }
}

enum EnergyUnit: String, CaseIterable {
    case kcal
    case kj = "kJ"

    var label: String { rawValue }

    func displayValue(fromKcal value: Double) -> Double {
        switch self {
        case .kcal:
            return value
        case .kj:
            return value * 4.184
        }
    }

    func kcalValue(from value: Double) -> Double {
        switch self {
        case .kcal:
            return value
        case .kj:
            return value / 4.184
        }
    }
}
