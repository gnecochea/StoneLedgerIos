//
//  ClientRepository.swift
//  StoneLedger
//
//  Created by csuftitan
//

import CoreData

final class ClientRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [Client] {
        let request: NSFetchRequest<Client> = Client.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "businessName", ascending: true)]
        return try context.fetch(request)
    }

    func fetch(byId id: UUID) throws -> Client? {
        let request: NSFetchRequest<Client> = Client.fetchRequest()
        request.predicate = NSPredicate(format: "clientId == %@", id as CVarArg)
        return try context.fetch(request).first
    }

    func insert(
        businessName: String,
        ownerName: String?,
        phone: String?,
        address: String?,
        sellerPermit: String?,
        notes: String?
    ) throws {
        let newClient = Client(context: context)
        newClient.clientId = UUID()
        newClient.businessName = businessName
        newClient.ownerName = ownerName
        newClient.phone = phone
        newClient.address = address
        newClient.sellerPermit = sellerPermit
        newClient.notes = notes

        try context.save()
    }

    func update(_ client: Client) throws {
        try context.save()
    }

    func delete(_ client: Client) throws {
        context.delete(client)
        try context.save()
    }
}

