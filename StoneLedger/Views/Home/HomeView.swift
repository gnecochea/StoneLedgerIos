//
//  HomeView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        List {
            NavigationLink("Clients") {
                ClientsListView()
            }

            NavigationLink("Items") {
                ItemsListView()
            }

            NavigationLink("Receipts") {
                ReceiptsListView()
            }

            NavigationLink("New Receipt") {
                NewReceiptView()
            }

            Button(role: .destructive) {
                authViewModel.logout()
            } label: {
                Text("Logout")
            }
        }
        .navigationTitle("StoneLedger")
    }
}
