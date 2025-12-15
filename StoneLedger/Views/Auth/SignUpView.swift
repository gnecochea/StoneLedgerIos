//
//  SignUpView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var localError: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .font(.title)
                .bold()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            if let localError {
                ErrorText(message: localError)
            } else if case .error(let msg) = authViewModel.authState {
                ErrorText(message: msg)
            }

            PrimaryButton(title: "Sign Up") {
                guard password == confirmPassword else {
                    localError = "Passwords do not match."
                    return
                }
                localError = nil
                authViewModel.signup(email: email, password: password)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}
