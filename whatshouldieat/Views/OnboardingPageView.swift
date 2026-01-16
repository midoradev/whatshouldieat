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
        case .cuisines:
            cuisinesIllustration
        case .nutrition:
            nutritionIllustration
        case .goals:
            goalsIllustration
        }
    }

    private var cuisinesIllustration: some View {
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
                    .fill(step.accent.opacity(0.12))
                    .frame(width: 180, height: 180)
                    .overlay(
                        Circle()
                            .stroke(step.accent.opacity(0.35), style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                    )

                Image(systemName: "globe")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(step.accent)

                iconBadge(symbol: "fork.knife", color: step.accent)
                    .offset(x: -110, y: -90)
                iconBadge(symbol: "cup.and.saucer", color: step.accent)
                    .offset(x: 110, y: -70)
                iconBadge(symbol: "leaf", color: step.accent)
                    .offset(x: -100, y: 90)
                iconBadge(symbol: "flame", color: step.accent)
                    .offset(x: 110, y: 100)
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

    private var goalsIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [step.accent.opacity(0.1), Color(hex: 0xFDE7DA)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(16)

            VStack(spacing: 16) {
                targetBadge

                HStack(spacing: 12) {
                    statPill(title: "Daily Goal", value: "1,850 kcal")
                    statPill(title: "Protein", value: "120 g")
                }
            }
            .padding(.horizontal, 24)

            iconBadge(symbol: "checkmark", color: step.accent)
                .offset(x: 120, y: -110)
            iconBadge(symbol: "leaf", color: Color(hex: 0x35B57A))
                .offset(x: -120, y: 110)
        }
        .frame(height: 320)
    }

    private var targetBadge: some View {
        ZStack {
            Circle()
                .stroke(step.accent.opacity(0.15), lineWidth: 14)
                .frame(width: 140, height: 140)
            Circle()
                .stroke(step.accent.opacity(0.35), lineWidth: 8)
                .frame(width: 100, height: 100)
            Circle()
                .fill(step.accent.opacity(0.2))
                .frame(width: 56, height: 56)
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(step.accent)
        }
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(step.mutedText)
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(step.titleText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
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
    case cuisines
    case nutrition
    case goals

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .cuisines:
            return "Explore World Cuisines"
        case .nutrition:
            return "Track Your Nutrition"
        case .goals:
            return "Reach Your Goals"
        }
    }

    var subtitle: String {
        switch self {
        case .cuisines:
            return "Discover delicious meals from over 50 countries at your fingertips."
        case .nutrition:
            return "Log your meals easily and keep an eye on your daily calories and macros."
        case .goals:
            return "Set your health targets and let us help you find the perfect meals to stay on track."
        }
    }

    var ctaTitle: String {
        self == .goals ? "Get Started" : "Next"
    }

    var accent: Color {
        switch self {
        case .cuisines, .goals:
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
        case .cuisines:
            return Color(hex: 0xFAFAF9)
        case .nutrition:
            return Color(hex: 0xF9FAFA)
        case .goals:
            return Color(hex: 0xFCF9F8)
        }
    }

    var surface: Color {
        switch self {
        case .cuisines:
            return Color(hex: 0xF7F3EE)
        case .nutrition, .goals:
            return Color.white
        }
    }

    var titleText: Color {
        switch self {
        case .nutrition:
            return Color(hex: 0x0E1B18)
        case .cuisines, .goals:
            return Color(hex: 0x1C120D)
        }
    }

    var mutedText: Color {
        switch self {
        case .cuisines:
            return Color(hex: 0x6B645E)
        case .nutrition:
            return Color(hex: 0x51625D)
        case .goals:
            return Color(hex: 0x5E4D46)
        }
    }
}

#Preview {
    OnboardingPageView()
}
