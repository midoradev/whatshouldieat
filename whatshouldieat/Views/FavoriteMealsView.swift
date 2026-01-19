import SwiftUI

struct FavoriteMealsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var searchQuery = ""

    private let meals = FavoriteMeal.sample

    private var filteredMeals: [FavoriteMeal] {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return meals }
        let query = trimmed.lowercased()
        return meals.filter {
            $0.title.lowercased().contains(query) ||
            $0.region.lowercased().contains(query) ||
            $0.country.lowercased().contains(query)
        }
    }

    var body: some View {
        let palette = ProfilePalette(scheme: colorScheme)

        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("12 Saved Items")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(palette.mutedText)
                        .textCase(.uppercase)
                        .tracking(1)
                    Spacer()
                    Button { } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 12, weight: .bold))
                            Text("Filter")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(palette.brandOrange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(palette.brandOrange.opacity(0.12))
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }

                VStack(spacing: 12) {
                    ForEach(filteredMeals) { meal in
                        FavoriteMealCard(meal: meal, palette: palette)
                    }
                }

                VStack(spacing: 6) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(palette.mutedText)
                    Text("Explore more to find new favorites")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }
                .padding(.top, 16)
                .opacity(0.6)
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
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(palette.brandOrange)
                            .frame(width: 32, height: 32)
                            .background(palette.primary.opacity(0.2))
                            .clipShape(Circle())
                    }
                    Text("Favorite Meals")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(palette.text)
                }

                Spacer()

                Button("Edit") { }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(palette.brandOrange)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(palette.mutedText)
                TextField("Search saved meals...", text: $searchQuery)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(palette.card)
            .cornerRadius(14)
            .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(palette.headerBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(palette.border.opacity(0.4)),
            alignment: .bottom
        )
    }
}

private struct FavoriteMealCard: View {
    let meal: FavoriteMeal
    let palette: ProfilePalette

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: meal.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(palette.card)
            }
            .frame(width: 72, height: 72)
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 8) {
                    Text(meal.title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(palette.text)
                        .lineLimit(2)
                    Spacer(minLength: 4)
                    Button { } label: {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.red)
                            .frame(width: 26, height: 26)
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: 6) {
                    Image(systemName: "globe")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(palette.mutedText)
                    Text("\(meal.country) - \(meal.region)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.mutedText)
                }

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(palette.brandOrange)
                        Text(meal.calories)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(palette.text)
                    }

                    Spacer()

                    Button { } label: {
                        Text("View Macros")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(palette.brandOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(palette.primary.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(palette.card)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(palette.border.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: palette.shadow, radius: 10, x: 0, y: 6)
    }
}

private struct FavoriteMeal: Identifiable {
    let id = UUID()
    let title: String
    let country: String
    let region: String
    let calories: String
    let imageURL: URL

    static let sample: [FavoriteMeal] = [
        FavoriteMeal(
            title: "Spicy Basil Chicken",
            country: "Thailand",
            region: "Pad Krapow",
            calories: "450 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3")!
        ),
        FavoriteMeal(
            title: "Grilled Salmon with Miso",
            country: "Japan",
            region: "Seafood",
            calories: "320 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3")!
        ),
        FavoriteMeal(
            title: "Authentic Beef Tacos",
            country: "Mexico",
            region: "Street Food",
            calories: "580 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3")!
        ),
        FavoriteMeal(
            title: "Quinoa Greek Salad",
            country: "Greece",
            region: "Mediterranean",
            calories: "280 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3")!
        ),
        FavoriteMeal(
            title: "Butter Chicken",
            country: "India",
            region: "Murgh Makhani",
            calories: "620 kcal",
            imageURL: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH00ue3cSZxntd83vg2t14nmzKwPvZXqDbXCRSQpG6UBk3yIRhaiyagzkgBoxy1ODb_7peM-roMbGBPx97XCvhQQzvwygxYwXGOvB3LwtDyBhe9K8cZHLDjH35YnOCa-epb2cPKDE8vxmCwKNLWP2rZqJE60hRe7ceqhH_wq4dCtEBj_ZZ-xedVJ3QoNX6-ODaCxv5eLr7pxwCvvybqpRM2FEhyZT5Cx5oTNA_H1wH7lu-4wYuJ8MlLfCnyC7RpgmHC-y8wzYvrbu3")!
        ),
    ]
}

#Preview {
    FavoriteMealsView()
}
