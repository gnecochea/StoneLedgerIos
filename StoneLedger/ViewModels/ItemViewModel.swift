//
//  ItemViewModel.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

final class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var filteredItems: [Item] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil

    private let repository: ItemRepository
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext) {
        self.context = context
        self.repository = ItemRepository(context: context)

        setupSearchPipeline()
        loadItems()
    }

    func loadItems() {
        do {
            items = try repository.fetchAll()
            filteredItems = items
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func setupSearchPipeline() {
        $searchQuery
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ query: String) {
        do {
            if query.isEmpty {
                filteredItems = items
            } else {
                filteredItems = try repository.search(query: query)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addItem(_ item: Item) {
        do {
            try repository.insert(item: item)
            loadItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateItem(_ item: Item) {
        do {
            try repository.update(item)
            loadItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteItem(_ item: Item) {
        do {
            try repository.delete(item)
            loadItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
