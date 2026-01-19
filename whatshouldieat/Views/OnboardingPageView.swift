//
//  OnboardingPageView.swift
//  whatshouldieat
//
//  Created by Lucas Nguyen on 15/1/26.
//

import SwiftUI

struct OnboardingPageView: View {
    @State private var selection = 0
    var onFinish: (() -> Void)?

    private let steps = OnboardingStep.allCases

    private var currentStep: OnboardingStep {
        let index = min(max(selection, 0), steps.count - 1)
        return steps[index]
    }

    var body: some View {
        ZStack {
            currentStep.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 12)

                TabView(selection: $selection) {
                    ForEach(steps) { step in
                        OnboardingStepView(step: step)
                            .tag(step.rawValue)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: selection)

                VStack(spacing: 20) {
                    pageIndicators

                    Button(action: advance) {
                        Text(currentStep.ctaTitle)
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(currentStep.accent)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: currentStep.accent.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }

    private var pageIndicators: some View {
        HStack(spacing: 10) {
            ForEach(steps.indices, id: \.self) { index in
                if index == selection {
                    Capsule()
                        .fill(currentStep.accent)
                        .frame(width: 28, height: 8)
                } else {
                    Circle()
                        .fill(currentStep.accent.opacity(0.2))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    private func advance() {
        if selection < steps.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                selection += 1
            }
        } else {
            onFinish?()
        }
    }
}

private struct OnboardingStepView: View {
    let step: OnboardingStep

    var body: some View {
        VStack(spacing: 24) {
            illustration

            VStack(spacing: 12) {
                Text(step.title)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(step.titleText)
                    .multilineTextAlignment(.center)

                Text(step.subtitle)
                    .font(.system(size: 17))
                    .foregroundColor(step.mutedText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 6)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private var illustration: some View {
        switch step {
        case .shake:
            shakeIllustration
        case .nutrition:
            nutritionIllustration
        case .discover:
            discoverIllustration
        }
    }

    private var shakeIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(step.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)

            ZStack {
                shakeLine(width: 48)
                    .offset(x: -132, y: -24)
                    .rotationEffect(.degrees(12))
                shakeLine(width: 32)
                    .offset(x: -116, y: 14)
                    .rotationEffect(.degrees(-12))
                shakeLine(width: 48)
                    .offset(x: 132, y: -24)
                    .rotationEffect(.degrees(-12))
                shakeLine(width: 32)
                    .offset(x: 116, y: 14)
                    .rotationEffect(.degrees(12))

                phoneCard
                    .rotationEffect(.degrees(6))

                iconBadge(symbol: "fork.knife", color: step.accent)
                    .offset(x: -92, y: -122)
                iconBadge(symbol: "takeoutbag.and.cup.and.straw", color: step.accent)
                    .offset(x: 122, y: -54)
                iconBadge(symbol: "leaf", color: step.accent)
                    .offset(x: -126, y: 64)
                iconBadge(symbol: "cup.and.saucer", color: step.accent)
                    .offset(x: 92, y: 118)
            }
        }
        .frame(height: 320)
    }

    private var nutritionIllustration: some View {
        ZStack {
            Circle()
                .fill(step.accent.opacity(0.1))
                .frame(width: 240, height: 240)
                .blur(radius: 12)

            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 10)
                .frame(width: 210, height: 330)
                .overlay(phoneContent, alignment: .top)

            iconBadge(symbol: "leaf", color: Color(hex: 0x2ECC71))
                .offset(x: 120, y: -110)
                .rotationEffect(.degrees(12))
            iconBadge(symbol: "fork.knife", color: step.accent)
                .offset(x: -120, y: 90)
                .rotationEffect(.degrees(-12))
            iconBadge(symbol: "bolt.heart", color: step.secondaryAccent)
                .offset(x: 130, y: 20)
                .rotationEffect(.degrees(6))
        }
        .frame(height: 320)
    }

    private var phoneContent: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.black.opacity(0.1))
                .frame(width: 70, height: 6)
                .padding(.top, 16)

            NutritionRing(accent: step.accent, textColor: step.titleText)

            VStack(spacing: 10) {
                MacroBar(value: 0.7, color: step.accent)
                MacroBar(value: 0.45, color: step.secondaryAccent)
                MacroBar(value: 0.3, color: Color(hex: 0xF5C84B))
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 0)
        }
    }

    private var discoverIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(step.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)

            ZStack {
                Circle()
                    .fill(step.accent.opacity(0.1))
                    .frame(width: 192, height: 192)
                    .overlay(
                        Circle()
                            .stroke(step.accent.opacity(0.3), style: StrokeStyle(lineWidth: 4, dash: [8, 6]))
                    )

                Image(systemName: "globe")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(step.accent)

                bentoIcon(symbol: "fork.knife")
                    .offset(x: -120, y: -118)
                    .rotationEffect(.degrees(-12))
                bentoIcon(symbol: "takeoutbag.and.cup.and.straw")
                    .offset(x: 120, y: -98)
                    .rotationEffect(.degrees(12))
                bentoIcon(symbol: "cup.and.saucer")
                    .offset(x: -112, y: 108)
                    .rotationEffect(.degrees(6))
                bentoIcon(symbol: "leaf")
                    .offset(x: 110, y: 114)
                    .rotationEffect(.degrees(-12))
            }
        }
        .frame(height: 320)
    }

    private func iconBadge(symbol: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
        }
        .frame(width: 44, height: 44)
    }

    private func bentoIcon(symbol: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
            Image(systemName: symbol)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(step.accent)
        }
        .frame(width: 52, height: 52)
    }

    private func shakeLine(width: CGFloat) -> some View {
        Capsule()
            .fill(step.accent.opacity(0.2))
            .frame(width: width, height: 6)
    }

    private var phoneCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(Color(hex: 0x1C120D))
                .overlay(
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .stroke(Color(hex: 0x3A3430), lineWidth: 6)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 18, x: 0, y: 12)

            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(step.accent.opacity(0.12))
                .frame(width: 102, height: 210)

            Image(systemName: "iphone.radiowaves.left.and.right")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(step.accent)

            Capsule()
                .fill(Color(hex: 0x3A3430))
                .frame(width: 46, height: 6)
                .offset(y: -112)
        }
        .frame(width: 130, height: 250)
    }
}

private struct NutritionRing: View {
    let accent: Color
    let textColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: 0xD1E6E2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: 0.65)
                .stroke(accent, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("CALORIES")
                    .font(.caption2)
                    .foregroundColor(textColor.opacity(0.6))
                Text("1,420")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(textColor)
            }
        }
        .frame(width: 120, height: 120)
    }
}

private struct MacroBar: View {
    let value: CGFloat
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.08))
                Capsule()
                    .fill(color)
                    .frame(width: proxy.size.width * value)
            }
        }
        .frame(height: 6)
    }
}

private enum OnboardingStep: Int, CaseIterable, Identifiable {
    case shake
    case nutrition
    case discover

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .shake:
            return "Shake to Decide"
        case .nutrition:
            return "Track Your Nutrition"
        case .discover:
            return "Discover World Cuisines"
        }
    }

    var subtitle: String {
        switch self {
        case .shake:
            return "Can't decide what to eat? Shake to get a global meal with ingredients and animated steps."
        case .nutrition:
            return "Log meals and see calories and macros update throughout your day."
        case .discover:
            return "Browse dishes from around the world and explore by country."
        }
    }

    var ctaTitle: String {
        self == .discover ? "Get Started" : "Next"
    }

    var accent: Color {
        switch self {
        case .shake:
            return Color(hex: 0xF66923)
        case .discover:
            return Color(hex: 0xF66923)
        case .nutrition:
            return Color(hex: 0x36E2C6)
        }
    }

    var secondaryAccent: Color {
        switch self {
        case .nutrition:
            return Color(hex: 0xF18D7A)
        default:
            return accent
        }
    }

    var background: Color {
        switch self {
        case .shake:
            return Color(hex: 0xFAFAF9)
        case .nutrition:
            return Color(hex: 0xF9FAFA)
        case .discover:
            return Color(hex: 0xFAFAF9)
        }
    }

    var surface: Color {
        switch self {
        case .shake:
            return Color(hex: 0xF7F3EE)
        case .nutrition:
            return Color.white
        case .discover:
            return Color(hex: 0xF7F3EE)
        }
    }

    var titleText: Color {
        switch self {
        case .nutrition:
            return Color(hex: 0x0E1B18)
        case .shake, .discover:
            return Color(hex: 0x1C120D)
        }
    }

    var mutedText: Color {
        switch self {
        case .shake:
            return Color(hex: 0x6B645E)
        case .nutrition:
            return Color(hex: 0x51625D)
        case .discover:
            return Color(hex: 0x6B645E)
        }
    }
}

#Preview {
    OnboardingPageView()
}
