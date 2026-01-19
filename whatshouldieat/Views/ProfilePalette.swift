import SwiftUI

struct ProfilePalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0xF0D9C2) }
    var brandOrange: Color { Color(hex: 0xF97316) }
    var brandTeal: Color { Color(hex: 0x14B8A6) }
    var brandYellow: Color { Color(hex: 0xF59E0B) }

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

    var shadow: Color {
        Color(hex: 0x8E7357).opacity(0.12)
    }
}
