import AuthenticationServices
import Combine
import Foundation
import Supabase

@MainActor
final class SupabaseAuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var session: Session?
    @Published private(set) var didReceiveRedirect = false

    private let client: SupabaseClient

    init() {
        self.client = SupabaseClientProvider.client
    }

    init(client: SupabaseClient) {
        self.client = client
    }

    func signInWithGoogle() {
        didReceiveRedirect = false
        signIn(provider: .google)
    }

    func signInWithApple() {
        didReceiveRedirect = false
        signIn(provider: .apple)
    }

    private func signIn(provider: Provider) {
        errorMessage = nil
        isLoading = true

        Task { @MainActor in
            defer { isLoading = false }
            do {
                let session = try await client.auth.signInWithOAuth(
                    provider: provider,
                    redirectTo: SupabaseClientProvider.redirectURL
                ) { session in
                    session.prefersEphemeralWebBrowserSession = true
                }
                self.session = session
                self.didReceiveRedirect = true
            } catch let error as ASWebAuthenticationSessionError where error.code == .canceledLogin {
                // User canceled the OAuth flow.
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func handleOAuthRedirect(_ url: URL) {
        guard url.scheme == SupabaseClientProvider.redirectURL.scheme else { return }
        didReceiveRedirect = true
    }

    var successMessage: String? {
        if let email = session?.user.email, !email.isEmpty {
            return "Signed in as \(email)."
        }

        if session != nil {
            return "Signed in successfully."
        }

        if didReceiveRedirect {
            return "OAuth callback received. Finishing sign-in..."
        }

        return nil
    }
}
