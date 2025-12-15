//
//  ClientsListView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ClientsListView: View {
    @EnvironmentObject var clientViewModel: ClientViewModel

    @State private var showingAddClient = false

    var body: some View {
        List {
            if clientViewModel.clients.isEmpty {
                Text("No clients yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(clientViewModel.clients, id: \.objectID) { client in
                    NavigationLink {
                        ClientFormView(clientToEdit: client)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(client.businessName ?? "")
                                .font(.headline)
                            if let phone = client.phone, !phone.isEmpty {
                                Text(phone)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteClients)
            }
        }
        .navigationTitle("Clients")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddClient = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddClient) {
            NavigationStack {
                ClientFormView()
            }
        }
    }

    private func deleteClients(at offsets: IndexSet) {
        offsets.map { clientViewModel.clients[$0] }.forEach { client in
            clientViewModel.deleteClient(client)
        }
    }
}
