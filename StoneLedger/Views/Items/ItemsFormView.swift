//
//  ItemFormView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ItemFormView: View {
    @EnvironmentObject var itemViewModel: ItemViewModel
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    var itemToEdit: Item? = nil

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var unitType: String = "PIECE"
    @State private var imageData: Data? = nil

    @State private var pricePerPiece: String = ""
    @State private var pricePerPound: String = ""
    @State private var pricePerDozen: String = ""

    var isEditing: Bool { itemToEdit != nil }

    let unitOptions = ["PIECE", "LB", "DOZEN"]

    var body: some View {
        Form {

            Section(header: Text("Basic Info")) {
                TextField("Name", text: $name)
                TextField("Category (optional)", text: $category)
            }

            Section(header: Text("Image")) {
                ImagePicker(imageData: $imageData)

                Text("This image will be copied into receipts at the time of sale.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("Default Unit Type")) {
                Picker("Unit", selection: $unitType) {
                    ForEach(unitOptions, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .pickerStyle(.segmented)

                Text("This unit type is the default mode when adding this item to a receipt. All pricing modes remain available.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }

            Section(header: Text("Pricing")) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Price per Piece")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    TextField("$0.00", text: $pricePerPiece)
                        .keyboardType(.decimalPad)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Price per Pound (LB)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    TextField("$0.00", text: $pricePerPound)
                        .keyboardType(.decimalPad)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Price per Dozen")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    TextField("$0.00", text: $pricePerDozen)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Item" : "New Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") { saveItem() }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear { loadExistingItem() }
    }

    private func loadExistingItem() {
        guard let item = itemToEdit else { return }

        name = item.name ?? ""
        category = item.category ?? ""
        unitType = item.unitType ?? "PIECE"

        pricePerPiece = String(item.pricePerPiece)
        pricePerPound = String(item.pricePerPound)
        pricePerDozen = String(item.pricePerDozen)

        imageData = item.imageData
    }

    private func saveItem() {
        let piece = Double(pricePerPiece) ?? 0
        let pound = Double(pricePerPound) ?? 0
        let dozen = Double(pricePerDozen) ?? 0

        if let existing = itemToEdit {
            existing.name = name
            existing.category = category.isEmpty ? nil : category
            existing.unitType = unitType
            existing.pricePerPiece = piece
            existing.pricePerPound = pound
            existing.pricePerDozen = dozen
            existing.imageData = imageData

            itemViewModel.updateItem(existing)
        } else {
            let newItem = Item(context: context)
            newItem.itemId = UUID()
            newItem.name = name
            newItem.category = category.isEmpty ? nil : category
            newItem.unitType = unitType
            newItem.pricePerPiece = piece
            newItem.pricePerPound = pound
            newItem.pricePerDozen = dozen
            newItem.imageData = imageData

            itemViewModel.addItem(newItem)
        }

        dismiss()
    }
}
