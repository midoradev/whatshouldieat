import SwiftUI

struct DiscoverView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchQuery = ""
    @State private var selectedFilter = "All"

    private let filters = ["All", "Vegan", "Keto", "Gluten-Free", "Low Carb"]
    private let trendingCuisines = TrendingCuisine.sample
    private let mapRegions = MapRegion.sample
    private let mapDots = MapDot.sample

    var body: some View {
        let palette = DiscoverPalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 24) {
                regionSection(palette: palette)
                trendingSection(palette: palette)
            }
            .padding(.bottom, 24)
        }
        .background(palette.background.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            header(palette: palette)
        }
    }

    private func header(palette: DiscoverPalette) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Discover")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Spacer()
                AsyncImage(url: URL(string: TrendingCuisine.avatarURL)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(palette.primary.opacity(0.3))
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(palette.primary.opacity(0.3), lineWidth: 2)
                )
            }

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(palette.mutedText)
                TextField("Search cuisines, dishes, or countries...", text: $searchQuery)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(palette.card)
            .cornerRadius(14)
            .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            selectedFilter = filter
                        } label: {
                            Text(filter)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(selectedFilter == filter ? palette.text : palette.mutedText)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? palette.primary : palette.card)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(palette.border.opacity(selectedFilter == filter ? 0 : 0.4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border.opacity(0.4)),
            alignment: .bottom
        )
    }

    private func regionSection(palette: DiscoverPalette) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Explore Regions")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(palette.mutedText)
                    .textCase(.uppercase)
                Spacer()
                Text("Interactive Map")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(palette.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(palette.primary.opacity(0.15))
                    .cornerRadius(10)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(palette.mapGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(palette.primary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: palette.shadow, radius: 14, x: 0, y: 8)

                GeometryReader { proxy in
                    ForEach(mapDots) { dot in
                        Circle()
                            .fill(palette.primary.opacity(0.25))
                            .frame(width: dot.size, height: dot.size)
                            .position(x: proxy.size.width * dot.x, y: proxy.size.height * dot.y)
                    }

                    ForEach(mapRegions) { region in
                        mapRegionTag(region: region, palette: palette)
                            .position(x: proxy.size.width * region.x, y: proxy.size.height * region.y)
                    }

                    Button { } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(palette.text)
                            .frame(width: 32, height: 32)
                            .background(palette.card)
                            .clipShape(Circle())
                            .shadow(color: palette.shadow, radius: 8, x: 0, y: 4)
                    }
                    .position(x: proxy.size.width - 26, y: proxy.size.height - 22)
                }
                .padding(10)
            }
            .frame(height: 190)
        }
        .padding(.horizontal, 16)
    }

    private func mapRegionTag(region: MapRegion, palette: DiscoverPalette) -> some View {
        HStack(spacing: 6) {
            Image(systemName: region.isHighlighted ? "globe.americas.fill" : "globe")
                .font(.system(size: 10, weight: .bold))
            Text(region.title)
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(region.isHighlighted ? palette.text : palette.text)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(region.isHighlighted ? palette.primary : palette.card.opacity(0.95))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(palette.primary.opacity(region.isHighlighted ? 0.4 : 0.2), lineWidth: 1)
        )
        .shadow(color: palette.shadow, radius: 6, x: 0, y: 4)
    }

    private func trendingSection(palette: DiscoverPalette) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Cuisines")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(palette.text)
                Spacer()
                Button { } label: {
                    Text("See All")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(palette.primary)
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(trendingCuisines) { cuisine in
                    TrendingCuisineCard(cuisine: cuisine, palette: palette)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct TrendingCuisineCard: View {
    let cuisine: TrendingCuisine
    let palette: DiscoverPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: cuisine.imageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(palette.card)
                }
                .frame(height: 120)
                .clipped()

                LinearGradient(
                    colors: [Color.black.opacity(0.55), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 120)

                Text(cuisine.region)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.35))
                    .cornerRadius(8)
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(cuisine.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(palette.text)

                HStack {
                    Text(cuisine.averageCalories)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                    Spacer()
                    Circle()
                        .fill(palette.accentMint)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: 0x0F766E))
                        )
                }
            }
            .padding(10)
        }
        .background(palette.card)
        .cornerRadius(16)
        .shadow(color: palette.shadow, radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct TrendingCuisine: Identifiable {
    let id = UUID()
    let title: String
    let region: String
    let averageCalories: String
    let imageURL: URL

    static let avatarURL =
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3"

    static let sample: [TrendingCuisine] = [
        TrendingCuisine(
            title: "Miso Ramen",
            region: "Japan",
            averageCalories: "Avg. 480 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDtHUASTBrjqY29nrW23qdWm8F7OcqX5pqARDJSGtbGcigbmzrEPX1qjepE0-1IT2_wpEg4pY_KWnqXbbk_kuHNgieYQUqvsiPrHr_EThIjCzKEnPaPgVVqXWh_MW6TlcXXPltAUkwUntaqG9Ula5oE5CJIZIYbAbEycXuaWSd6DH9PprTcfokKLA_RcpgrPh8ytGOtC_qcVk1Com44e8TFImA6IQJ4CSuH162G8ZWx_vpHK2ZUPE7FS8FLA8eI_XZcxgMshVVWtA6B")!
        ),
        TrendingCuisine(
            title: "Street Tacos",
            region: "Mexico",
            averageCalories: "Avg. 320 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBgb755-_CEUyTbYsW4EPE5gRX1UAyM4vONTaxfUs2Zr9q_Ij9Zm1si2GHRij23ECFf0hpC23i5giAa470O-f4x1xbY7xbIxmSi73wM2ebn9xVuwrpsmjAG6UXoOkDFGxX47FgB3Rs0b_ogN-XshB-QYugu3fvz_KmidQbyTrd81d0Ph0IFUUT67lLy72t4D6dRPks-ahfkt4uuCWML5DHxrPwE5x6FqOvP5MG9RNvTpLoyPH5-S9EajcgRH8buY2BOErHN4tgMq6Dy")!
        ),
        TrendingCuisine(
            title: "Neapolitan Pizza",
            region: "Italy",
            averageCalories: "Avg. 650 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuAUy7WixLnAsueiHhh_NoGImDxHyhK2TKfSq-2TAe06i37qn82H7mmh5s4zh50oCMuHfScNez_Ha-ZwVD3RVI_-HV0lzWOBpih0fmtKcgc8ra8ZzwdtvJ6we3rmJOnrGCyacSKOmTiECUHPjAgRM6a0OH5_78Q7KFc1zUmrWELyE6V62c4_cUdbtOIS6K9Po2hRnpOU-CtDVDVPfVJcd8EJAEOJ8zpg-VpCr7pRu-UG6dCs4yxiaiJ9ep2SmAFDW4_W6hHl608JhD-0")!
        ),
        TrendingCuisine(
            title: "Shakshuka",
            region: "Tunisia",
            averageCalories: "Avg. 290 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDSVVXxICOiZ38kQOA0B4akkJnzv0-Af0G1aq0oR8wywehTQA5JB_Rj6KdD7KDyZdH5VGK2aRi_lp4C7uyWDeHGLJ1I0yP33GbTJdo2Y8ITpoyPE5b6R5QASFW_uuL3Y2Di3g4SSU9OB6IJY8Wv0fp_zNEuKNrjO0Ep3B-d8lCZ373bj-8CV8Oi-N-Z2ncTUk5S1Ul2vEz5OMt20SFbI6svUHoYmnrRIPq4vHaOTIlfYUq7mSm_0zLjsXou-OVvXXxe1bAOzpn0bzrG")!
        ),
    ]
}

private struct MapRegion: Identifiable {
    let id = UUID()
    let title: String
    let x: CGFloat
    let y: CGFloat
    let isHighlighted: Bool

    static let sample: [MapRegion] = [
        MapRegion(title: "Americas", x: 0.22, y: 0.28, isHighlighted: false),
        MapRegion(title: "Europe & Africa", x: 0.5, y: 0.44, isHighlighted: false),
        MapRegion(title: "Asia Pacific", x: 0.76, y: 0.34, isHighlighted: true),
    ]
}

private struct MapDot: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat

    static let sample: [MapDot] = [
        MapDot(x: 0.2, y: 0.55, size: 60),
        MapDot(x: 0.56, y: 0.68, size: 70),
        MapDot(x: 0.78, y: 0.52, size: 65),
        MapDot(x: 0.44, y: 0.28, size: 50),
    ]
}

private struct DiscoverPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0xF0D9C2) }
    var accentMint: Color { Color(hex: 0xE0F2F1) }

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

    var mapGradient: RadialGradient {
        let start = scheme == .dark ? Color(hex: 0x2A221A) : Color(hex: 0xFDF8F4)
        return RadialGradient(colors: [start, primary], center: .center, startRadius: 40, endRadius: 200)
    }
}

#Preview {
    DiscoverView()
}
