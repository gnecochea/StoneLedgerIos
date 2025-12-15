//
//  RootView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        switch authViewModel.authState {
        case .unauthenticated, .error:
            AuthStackView()

        case .loading:
            VStack {
                ProgressView()
                Text("Signing in...")
            }

        case .authenticated:
            MainAppView()
        }
    }
}
