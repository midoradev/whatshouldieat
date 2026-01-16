import SwiftUI

@MainActor
struct CredentialsLoginView: View {
    var onBack: (() -> Void)? = nil
    var onSuccess: (() -> Void)? = nil

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var didSucceed = false

    private let requiredUsername = "Lucas"
    private let requiredPassword = "lucasdev"

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let palette = CredentialsPalette(scheme: colorScheme)

        ZStack {
            palette.background.ignoresSafeArea()

            CredentialsBackground(primary: palette.primary, scheme: colorScheme)
                .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        header(palette: palette)

                        Spacer(minLength: 24)

                        VStack(spacing: 20) {
                            VStack(spacing: 10) {
                                Text("Login with Credentials")
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundColor(palette.text)
                                    .multilineTextAlignment(.center)

                                Text("Use the assigned username and password to sign in.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(palette.textMuted)
                                    .multilineTextAlignment(.center)
                            }

                            VStack(spacing: 14) {
                                credentialsField(
                                    title: "Username",
                                    placeholder: "Enter username",
                                    text: $username,
                                    isSecure: false,
                                    palette: palette
                                )

                                credentialsField(
                                    title: "Password",
                                    placeholder: "Enter password",
                                    text: $password,
                                    isSecure: true,
                                    palette: palette
                                )
                            }

                            Text("Use your assigned username and password to continue.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(palette.textMuted)

                            Button {
                                validateCredentials()
                            } label: {
                                Text("Login")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(palette.primary)
                                    .foregroundColor(palette.text)
                                    .cornerRadius(18)
                                    .shadow(color: palette.primary.opacity(0.25), radius: 10, x: 0, y: 6)
                            }

                            statusMessage(palette: palette)
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)

                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: 480)
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func header(palette: CredentialsPalette) -> some View {
        ZStack {
            HStack {
                Button {
                    onBack?()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(palette.text)
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

    private func credentialsField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool,
        palette: CredentialsPalette
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(palette.text)

            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                        .textInputAutocapitalization(.never)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(palette.card)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(palette.border, lineWidth: 1)
            )
            .cornerRadius(16)
            .font(.system(size: 16))
        }
    }

    private func statusMessage(palette: CredentialsPalette) -> some View {
        Group {
            if let errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.red.opacity(0.85))
                    .multilineTextAlignment(.center)
            } else if didSucceed {
                Text("Login successful.")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.green.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: 240)
    }

    private func validateCredentials() {
        if username == requiredUsername && password == requiredPassword {
            errorMessage = nil
            didSucceed = true
            onSuccess?()
        } else {
            didSucceed = false
            errorMessage = "Incorrect username or password."
        }
    }
}

private struct CredentialsBackground: View {
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
                    center: UnitPoint(x: 0.85, y: 0.1),
                    startRadius: 0,
                    endRadius: size * 0.55
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

private struct CredentialsPalette {
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
}

#Preview {
    CredentialsLoginView()
}
