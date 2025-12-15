//
//  ClientViewModel.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

final class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var errorMessage: String? = nil

    private let repository: ClientRepository
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.repository = ClientRepository(context: context)
        loadClients()
    }

    func loadClients() {
        do {
            clients = try repository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addClient(
        businessName: String,
        ownerName: String?,
        phone: String?,
        address: String?,
        sellerPermit: String?,
        notes: String?
    ) {
        do {
            try repository.insert(
                businessName: businessName,
                ownerName: ownerName,
                phone: phone,
                address: address,
                sellerPermit: sellerPermit,
                notes: notes
            )
            loadClients()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateClient(_ client: Client) {
        do {
            try repository.update(client)
            loadClients()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteClient(_ client: Client) {
        do {
            try repository.delete(client)
            loadClients()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
