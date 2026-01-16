import Foundation
import SwiftUI

@MainActor
struct LoginView: View {
    var onBack: (() -> Void)? = nil
    var onCredentialsLogin: (() -> Void)? = nil
    var onLoginSuccess: (() -> Void)? = nil

    @StateObject private var viewModel = SupabaseAuthViewModel(
        client: SupabaseClientProvider.client
    )
    @State private var didNotifySuccess = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let palette = LoginPalette(scheme: colorScheme)

        ZStack {
            palette.background.ignoresSafeArea()

            LoginBackground(primary: palette.primary, scheme: colorScheme)
                .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        header(palette: palette)

                        Spacer(minLength: 20)

                        VStack(spacing: 32) {
                            logo(palette: palette)

                            VStack(spacing: 12) {
                                Text("Start Your Culinary Journey")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    .foregroundColor(palette.text)
                                    .multilineTextAlignment(.center)

                                Text("Discover your next favorite meal in one tap.")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(palette.textMuted)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 12)

                            VStack(spacing: 14) {
                                googleButton(palette: palette)
                                appleButton(palette: palette)
                                credentialsButton(palette: palette)
                                statusMessage(palette: palette)
                            }

                            termsText(palette: palette)
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)

                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: 480)
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onOpenURL { url in
            viewModel.handleOAuthRedirect(url)
        }
        .onChange(of: viewModel.session) { _, session in
            guard session != nil, !didNotifySuccess else { return }
            didNotifySuccess = true
            onLoginSuccess?()
        }
        .onAppear {
            didNotifySuccess = false
        }
    }

    private func header(palette: LoginPalette) -> some View {
        ZStack {
            HStack {
                if onBack != nil {
                    Button {
                        onBack?()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(palette.text)
                            .frame(width: 44, height: 44)
                    }
                } else {
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                Spacer()
            }

            Text("What Should I Eat")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(palette.text)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private func logo(palette: LoginPalette) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(palette.card)
                .frame(width: 96, height: 96)
                .shadow(color: palette.primary.opacity(0.12), radius: 18, x: 0, y: 10)

            Image(systemName: "fork.knife")
                .font(.system(size: 44, weight: .semibold))
                .foregroundColor(palette.primary)
        }
    }

    private func googleButton(palette: LoginPalette) -> some View {
        Button {
            viewModel.signInWithGoogle()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(palette.primary.opacity(0.2))
                        .frame(width: 28, height: 28)
                    Text("G")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(palette.text)
                }

                Text("Continue with Google")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(palette.text)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(palette.card)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(palette.border, lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.isLoading)
    }

    private func appleButton(palette: LoginPalette) -> some View {
        Button {
            viewModel.signInWithApple()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "applelogo")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(palette.inverseText)

                Text("Continue with Apple")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(palette.inverseText)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(palette.inverseBackground)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
        }
        .disabled(viewModel.isLoading)
    }

    private func credentialsButton(palette: LoginPalette) -> some View {
        Button {
            onCredentialsLogin?()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "person.text.rectangle")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(palette.text)

                Text("Login with Username & Password")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(palette.text)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(palette.card)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(palette.border, lineWidth: 1)
            )
            .cornerRadius(18)
        }
        .disabled(viewModel.isLoading)
    }

    private func statusMessage(palette: LoginPalette) -> some View {
        Group {
            if viewModel.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .tint(palette.primary)
                    Text("Connecting...")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(palette.textMuted)
                }
            } else if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.green.opacity(0.85))
                    .multilineTextAlignment(.center)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.red.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: 260)
    }

    private func termsText(palette: LoginPalette) -> some View {
        var terms = AttributedString(
            "By continuing, you agree to our Terms of Service and Privacy Policy."
        )
        terms.font = .system(size: 13)
        terms.foregroundColor = palette.textMuted

        if let range = terms.range(of: "Terms of Service") {
            terms[range].foregroundColor = palette.primary
            terms[range].underlineStyle = .single
            terms[range].font = .system(size: 13, weight: .medium)
        }

        if let range = terms.range(of: "Privacy Policy") {
            terms[range].foregroundColor = palette.primary
            terms[range].underlineStyle = .single
            terms[range].font = .system(size: 13, weight: .medium)
        }

        return Text(terms)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
}

private struct LoginBackground: View {
    let primary: Color
    let scheme: ColorScheme

    var body: some View {
        GeometryReader { proxy in
            let size = max(proxy.size.width, proxy.size.height)
            let topOpacity = scheme == .dark ? 0.05 : 0.15
            let bottomOpacity = scheme == .dark ? 0.03 : 0.1

            ZStack {
                RadialGradient(
                    colors: [primary.opacity(topOpacity), .clear],
                    center: UnitPoint(x: 0.9, y: 0.05),
                    startRadius: 0,
                    endRadius: size * 0.6
                )

                RadialGradient(
                    colors: [primary.opacity(bottomOpacity), .clear],
                    center: UnitPoint(x: 0.1, y: 0.9),
                    startRadius: 0,
                    endRadius: size * 0.55
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct LoginPalette {
    let scheme: ColorScheme

    var primary: Color { Color(hex: 0xFFC48A) }

    var background: Color {
        scheme == .dark ? Color(hex: 0x1D140C) : .white
    }

    var card: Color {
        scheme == .dark ? Color(hex: 0x36312D) : .white
    }

    var text: Color {
        scheme == .dark ? .white : Color(hex: 0x1D140C)
    }

    var textMuted: Color {
        scheme == .dark ? Color.white.opacity(0.6) : Color(hex: 0x1D140C).opacity(0.6)
    }

    var border: Color {
        scheme == .dark ? Color(hex: 0x4A443E) : Color(hex: 0xEADBCD)
    }

    var inverseBackground: Color {
        scheme == .dark ? .white : .black
    }

    var inverseText: Color {
        scheme == .dark ? .black : .white
    }
}

#Preview {
    LoginView()
}
