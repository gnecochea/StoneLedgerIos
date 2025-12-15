//
//  ReceiptItemRepository.swift
//  StoneLedger
//
//  Created by csuftitan
//

import CoreData

final class ReceiptItemRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func insert(receiptItem: ReceiptItem) throws {
        try context.save()
    }

    func delete(_ receiptItem: ReceiptItem) throws {
        context.delete(receiptItem)
        try context.save()
    }

    func update(_ receiptItem: ReceiptItem) throws {
        try context.save()
    }

    func fetchByReceipt(_ receipt: Receipt) throws -> [ReceiptItem] {
        let request: NSFetchRequest<ReceiptItem> = ReceiptItem.fetchRequest()
        request.predicate = NSPredicate(format: "receipt == %@", receipt)
        return try context.fetch(request)
    }
}
