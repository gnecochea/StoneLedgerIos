//
//  ItemsListView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ItemsListView: View {
    @EnvironmentObject var itemViewModel: ItemViewModel

    @State private var showingAddItem = false

    var body: some View {
        VStack {
            TextField("Search items...", text: $itemViewModel.searchQuery)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding([.horizontal, .top])

            List {
                if itemViewModel.filteredItems.isEmpty {
                    Text("No items found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(itemViewModel.filteredItems, id: \.objectID) { item in
                        NavigationLink {
                            ItemFormView(itemToEdit: item)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(item.name ?? "")
                                    .font(.headline)

                                if let category = item.category, !category.isEmpty {
                                    Text(category)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                // Price summary (automatic, based on prices > 0)
                                if !priceSummary(for: item).isEmpty {
                                    Text(priceSummary(for: item))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        .navigationTitle("Items")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            NavigationStack {
                ItemFormView()
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        offsets.map { itemViewModel.filteredItems[$0] }.forEach { item in
            itemViewModel.deleteItem(item)
        }
    }

    private func priceSummary(for item: Item) -> String {
        var parts: [String] = []

        if item.pricePerPiece > 0 {
            parts.append(String(format: "Piece $%.2f", item.pricePerPiece))
        }
        if item.pricePerPound > 0 {
            parts.append(String(format: "LB $%.2f", item.pricePerPound))
        }
        if item.pricePerDozen > 0 {
            parts.append(String(format: "Dozen $%.2f", item.pricePerDozen))
        }

        return parts.joined(separator: " • ")
    }
}
