//
//  LoginView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("StoneLedger")
                .font(.largeTitle)
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

            if case .error(let msg) = authViewModel.authState {
                ErrorText(message: msg)
            }

            PrimaryButton(title: "Log In") {
                authViewModel.login(email: email, password: password)
            }

            NavigationLink("Don’t have an account? Sign up") {
                SignupView()
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .navigationTitle("Login")
    }
}
