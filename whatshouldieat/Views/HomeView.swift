import Foundation
import SwiftUI

@MainActor
struct HomeView: View {
    @State private var selectedCuisine: CuisineOption = .global
    @Environment(\.colorScheme) private var colorScheme

    private let meals = MealCard.sampleMeals

    var body: some View {
        let palette = HomePalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 28) {
                countrySelector(palette: palette)
                shakeSection(palette: palette)
                trendingSection(palette: palette)
            }
            .padding(.bottom, 24)
        }
        .background(palette.background.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            header(palette: palette)
        }
    }

    private func header(palette: HomePalette) -> some View {
        VStack(spacing: 12) {
            HStack {
                avatar(palette: palette)
                Spacer()
                Text("What Should I Eat")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Spacer()
                notificationButton(palette: palette)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            nutritionSummary(palette: palette)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border.opacity(0.6)),
            alignment: .bottom
        )
    }

    private func avatar(palette: HomePalette) -> some View {
        ZStack {
            Circle()
                .fill(palette.primary.opacity(0.2))
                .frame(width: 40, height: 40)
            AsyncImage(url: URL(string: MealCard.avatarURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Circle()
                    .fill(palette.primary.opacity(0.35))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(palette.primary.opacity(0.4), lineWidth: 2)
            )
        }
    }

    private func notificationButton(palette: HomePalette) -> some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(palette.primary.opacity(0.25))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "bell")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(palette.text)
                )

            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .stroke(palette.headerBackground, lineWidth: 2)
                )
                .offset(x: 6, y: -6)
        }
    }

    private func nutritionSummary(palette: HomePalette) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Calories")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(palette.mutedText)
                        .textCase(.uppercase)
                    Spacer()
                    Text("1,240")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(palette.text)
                    Text("/ 2,000")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(palette.progressTrack)
                        .frame(height: 8)
                    Capsule()
                        .fill(palette.primary)
                        .frame(width: 150, height: 8)
                }
            }

            Rectangle()
                .fill(palette.border.opacity(0.6))
                .frame(width: 1, height: 36)

            HStack(spacing: 14) {
                macroColumn(title: "P", value: "45g", palette: palette)
                macroColumn(title: "C", value: "120g", palette: palette)
                macroColumn(title: "F", value: "32g", palette: palette)
            }
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(16)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(palette.border.opacity(0.4), lineWidth: 1)
        )
    }

    private func macroColumn(title: String, value: String, palette: HomePalette) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(palette.mutedText)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(palette.text)
        }
    }

    private func countrySelector(palette: HomePalette) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(palette.primary)
                Text("Cooking from")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(palette.mutedText)
            }

            Menu {
                ForEach(CuisineOption.allCases) { option in
                    Button(option.label) {
                        selectedCuisine = option
                    }
                }
            } label: {
                HStack {
                    Text(selectedCuisine.label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(palette.text)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(palette.mutedText)
                }
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(palette.card)
                .cornerRadius(16)
                .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
            }
        }
        .padding(.horizontal, 16)
    }

    private func shakeSection(palette: HomePalette) -> some View {
        VStack(spacing: 18) {
            Button { } label: {
                ZStack {
                    Circle()
                        .fill(palette.primary)
                        .frame(width: 170, height: 170)
                        .shadow(color: palette.primary.opacity(0.6), radius: 18, x: 0, y: 10)

                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 3)
                        .frame(width: 150, height: 150)

                    VStack(spacing: 6) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(palette.text)
                        Text("Shake to Decide")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(palette.text)
                    }

                    Text("Randomizer")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(palette.card)
                        .foregroundColor(palette.primary)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(palette.primary.opacity(0.3), lineWidth: 1)
                        )
                        .offset(y: 86)
                }
            }
            .buttonStyle(.plain)

            Text("Not sure what to eat? Let the universe (and our algorithm) choose for you!")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(palette.mutedText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)
        }
        .padding(.horizontal, 16)
    }

    private func trendingSection(palette: HomePalette) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Today")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Spacer()
                Button { } label: {
                    HStack(spacing: 4) {
                        Text("View all")
                            .font(.system(size: 13, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(palette.primary)
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(meals) { meal in
                    MealCardView(meal: meal, palette: palette)
                }
            }
        }
        .padding(.horizontal, 16)
    }

}

private struct MealCardView: View {
    let meal: MealCard
    let palette: HomePalette

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: meal.imageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(palette.card)
                }
                .frame(height: 150)
                .clipped()

                LinearGradient(
                    colors: [Color.black.opacity(0.55), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 150)

                Text(meal.calories)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(palette.text)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(palette.accentMint)
                    .cornerRadius(8)
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(meal.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(palette.text)
                    .lineLimit(2)

                HStack {
                    Label(meal.time, systemImage: "clock")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                    Spacer()
                    Text(meal.region)
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(palette.accentLavender)
                        .foregroundColor(Color(hex: 0x6B4B9A))
                        .cornerRadius(6)
                }
            }
            .padding(10)
        }
        .background(palette.card)
        .cornerRadius(16)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 6)
    }
}

private struct MealCard: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let region: String
    let calories: String
    let imageURL: URL

    static let avatarURL =
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3"

    static let sampleMeals: [MealCard] = [
        MealCard(
            title: "Classic Shakshuka",
            time: "25 min",
            region: "North Africa",
            calories: "340 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDSVVXxICOiZ38kQOA0B4akkJnzv0-Af0G1aq0oR8wywehTQA5JB_Rj6KdD7KDyZdH5VGK2aRi_lp4C7uyWDeHGLJ1I0yP33GbTJdo2Y8ITpoyPE5b6R5QASFW_uuL3Y2Di3g4SSU9OB6IJY8Wv0fp_zNEuKNrjO0Ep3B-d8lCZ373bj-8CV8Oi-N-Z2ncTUk5S1Ul2vEz5OMt20SFbI6svUHoYmnrRIPq4vHaOTIlfYUq7mSm_0zLjsXou-OVvXXxe1bAOzpn0bzrG")!
        ),
        MealCard(
            title: "Tonkotsu Ramen",
            time: "15 min",
            region: "Japan",
            calories: "520 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDtHUASTBrjqY29nrW23qdWm8F7OcqX5pqARDJSGtbGcigbmzrEPX1qjepE0-1IT2_wpEg4pY_KWnqXbbk_kuHNgieYQUqvsiPrHr_EThIjCzKEnPaPgVVqXWh_MW6TlcXXPltAUkwUntaqG9Ula5oE5CJIZIYbAbEycXuaWSd6DH9PprTcfokKLA_RcpgrPh8ytGOtC_qcVk1Com44e8TFImA6IQJ4CSuH162G8ZWx_vpHK2ZUPE7FS8FLA8eI_XZcxgMshVVWtA6B")!
        ),
        MealCard(
            title: "Pizza Margherita",
            time: "35 min",
            region: "Italy",
            calories: "890 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuAUy7WixLnAsueiHhh_NoGImDxHyhK2TKfSq-2TAe06i37qn82H7mmh5s4zh50oCMuHfScNez_Ha-ZwVD3RVI_-HV0lzWOBpih0fmtKcgc8ra8ZzwdtvJ6we3rmJOnrGCyacSKOmTiECUHPjAgRM6a0OH5_78Q7KFc1zUmrWELyE6V62c4_cUdbtOIS6K9Po2hRnpOU-CtDVDVPfVJcd8EJAEOJ8zpg-VpCr7pRu-UG6dCs4yxiaiJ9ep2SmAFDW4_W6hHl608JhD-0")!
        ),
        MealCard(
            title: "Beef Barbacoa Tacos",
            time: "20 min",
            region: "Mexico",
            calories: "410 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBgb755-_CEUyTbYsW4EPE5gRX1UAyM4vONTaxfUs2Zr9q_Ij9Zm1si2GHRij23ECFf0hpC23i5giAa470O-f4x1xbY7xbIxmSi73wM2ebn9xVuwrpsmjAG6UXoOkDFGxX47FgB3Rs0b_ogN-XshB-QYugu3fvz_KmidQbyTrd81d0Ph0IFUUT67lLy72t4D6dRPks-ahfkt4uuCWML5DHxrPwE5x6FqOvP5MG9RNvTpLoyPH5-S9EajcgRH8buY2BOErHN4tgMq6Dy")!
        ),
    ]
}

private enum CuisineOption: String, CaseIterable, Identifiable {
    case global
    case italian
    case japanese
    case mexican
    case thai

    var id: String { rawValue }

    var label: String {
        switch self {
        case .global:
            return "Global Selection"
        case .italian:
            return "Italian Cuisine"
        case .japanese:
            return "Japanese Delights"
        case .mexican:
            return "Mexican Spice"
        case .thai:
            return "Thai Flavors"
        }
    }
}

private struct HomePalette {
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
        scheme == .dark ? Color.white.opacity(0.1) : Color(hex: 0xF2ECE7)
    }

    var shadow: Color {
        Color(hex: 0x8E7357).opacity(0.12)
    }
}

#Preview {
    HomeView()
}
