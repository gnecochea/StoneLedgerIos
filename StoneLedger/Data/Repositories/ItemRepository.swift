//
//  ItemRepository.swift
//  StoneLedger
//
//  Created by csuftitan
//

import CoreData

final class ItemRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return try context.fetch(request)
    }

    func search(query: String) throws -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        if !query.isEmpty {
            request.predicate = NSPredicate(
                format: "name CONTAINS[cd] %@ OR category CONTAINS[cd] %@",
                query, query
            )
        }

        return try context.fetch(request)
    }

    func insert(item: Item) throws {
        try context.save()
    }

    func delete(_ item: Item) throws {
        context.delete(item)
        try context.save()
    }

    func update(_ item: Item) throws {
        try context.save()
    }
}
