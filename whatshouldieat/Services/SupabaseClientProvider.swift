import Foundation
import Supabase

enum SupabaseClientProvider {
    static let redirectURL = URL(string: "whatshouldieat://login-callback")!

    static let client: SupabaseClient = {
        let options = SupabaseClientOptions(
            auth: .init(
                redirectToURL: redirectURL,
                emitLocalSessionAsInitialSession: true
            )
        )

        return SupabaseClient(
            supabaseURL: URL(string: "https://eiofffdilttthiqvzzzo.supabase.co")!,
            supabaseKey: "sb_publishable_sYfk7ssBEFMApvhEWhMqLw_o9blLHXp",
            options: options
        )
    }()
}
