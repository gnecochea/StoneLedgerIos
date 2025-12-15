//
//  ReceiptRepository.swift
//  StoneLedger
//
//  Created by csuftitan
//

import CoreData

final class ReceiptRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [Receipt] {
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(request)
    }

    func fetch(byId id: UUID) throws -> Receipt? {
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        request.predicate = NSPredicate(format: "receiptId == %@", id as CVarArg)
        return try context.fetch(request).first
    }

    func insert(receipt: Receipt) throws {
        try context.save()
    }

    func delete(_ receipt: Receipt) throws {
        context.delete(receipt)
        try context.save()
    }

    func update(_ receipt: Receipt) throws {
        try context.save()
    }
}
