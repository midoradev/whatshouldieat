//
//  ContentView.swift
//  whatshouldieat
//
//  Created by Lucas Nguyen on 14/1/26.
//

import SwiftUI

struct ContentView: View {
    @State private var screen: RootScreen = .onboarding
    @State private var hasCompletedAuth = false

    var body: some View {
        Group {
            switch screen {
            case .onboarding:
                OnboardingPageView {
                    screen = .login
                }
            case .login:
                LoginView(
                    onBack: hasCompletedAuth ? nil : { screen = .onboarding },
                    onCredentialsLogin: { screen = .credentialsLogin },
                    onLoginSuccess: {
                        hasCompletedAuth = true
                        screen = .home
                    }
                )
            case .credentialsLogin:
                CredentialsLoginView(
                    onBack: hasCompletedAuth ? nil : { screen = .login },
                    onSuccess: {
                        hasCompletedAuth = true
                        screen = .home
                    }
                )
            case .home:
                HomeView()
            }
        }
        .onChange(of: hasCompletedAuth) { _, completed in
            if completed {
                screen = .home
            }
        }
    }
}

private enum RootScreen {
    case onboarding
    case login
    case credentialsLogin
    case home
}

#Preview {
    ContentView()
}
