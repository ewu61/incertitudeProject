import SwiftUI
import FirebaseCore

@main
struct incertitudeApp: App {
    init() {
        FirebaseApp.configure()
    }

    @State private var isUserLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                MainContentView(isUserLoggedIn: $isUserLoggedIn)  // Pass the login state to MainContentView
            } else {
                LoginView(isUserLoggedIn: $isUserLoggedIn)  // Pass the login state to LoginView
            }
        }
    }
}
