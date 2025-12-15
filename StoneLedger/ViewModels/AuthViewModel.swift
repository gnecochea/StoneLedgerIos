import SwiftUI
import Combine
import FirebaseAuth

enum AuthState {
    case unauthenticated
    case loading
    case authenticated
    case error(String)
}

final class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .unauthenticated
    @Published var userEmail: String? = nil

    init() {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email
            self.authState = .authenticated
        }
    }

    func login(email: String, password: String) {
        authState = .loading
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.authState = .error(error.localizedDescription)
                return
            }
            self?.userEmail = result?.user.email
            self?.authState = .authenticated
        }
    }

    func signup(email: String, password: String) {
        authState = .loading
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.authState = .error(error.localizedDescription)
                return
            }
            self?.userEmail = result?.user.email
            self?.authState = .authenticated
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        userEmail = nil
        authState = .unauthenticated
    }
}
