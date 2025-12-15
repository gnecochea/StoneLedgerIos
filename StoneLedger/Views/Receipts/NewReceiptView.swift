//
//  NewReceiptView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct NewReceiptView: View {
    @EnvironmentObject var clientViewModel: ClientViewModel
    @EnvironmentObject var itemViewModel: ItemViewModel
    @EnvironmentObject var receiptViewModel: ReceiptViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItem: Item? = nil
    @State private var quantityText: String = "1"
    @State private var selectedPriceMode: String = "PIECE"

    let paymentOptions = ["CASH", "CARD", "ZELLE"]
    let saleOptions = ["RETAIL", "WHOLESALE"]

    private var priceModesForSelectedItem: [String] {
        guard let item = selectedItem else { return [] }

        var modes: [String] = []
        if item.pricePerPiece > 0     { modes.append("PIECE") }
        if item.pricePerPound > 0     { modes.append("LB") }
        if item.pricePerDozen > 0     { modes.append("DOZEN") }

        return modes
    }

    private var currentUnitPrice: Double {
        guard let item = selectedItem else { return 0 }

        switch selectedPriceMode {
        case "PIECE": return item.pricePerPiece
        case "LB":    return item.pricePerPound
        case "DOZEN": return item.pricePerDozen
        default:      return 0
        }
    }

    private var currentLineTotal: Double {
        let qty = Double(quantityText) ?? 0
        return currentUnitPrice * qty
    }

    var body: some View {
        Form {

            Section(header: Text("Client")) {
                Menu {
                    Button("No Client") { receiptViewModel.selectedClient = nil }
                    ForEach(clientViewModel.clients, id: \.objectID) { client in
                        Button(client.businessName ?? "") {
                            receiptViewModel.selectedClient = client
                        }
                    }
                } label: {
                    HStack {
                        Text("Selected:")
                        Spacer()
                        Text(currentClientLabel)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section(header: Text("Sale Details")) {
                Picker("Payment", selection: $receiptViewModel.paymentType) {
                    ForEach(paymentOptions, id: \.self) { Text($0) }
                }
                Picker("Sale Type", selection: $receiptViewModel.saleType) {
                    ForEach(saleOptions, id: \.self) { Text($0) }
                }
            }

            Section(header: Text("Add Item")) {

                Menu {
                    ForEach(itemViewModel.items, id: \.objectID) { item in
                        Button(item.name ?? "") {
                            selectedItem = item

                            selectedPriceMode = priceModesForSelectedItem.first ?? "PIECE"
                        }
                    }
                } label: {
                    HStack {
                        Text("Item")
                        Spacer()
                        Text(selectedItem?.name ?? "Select Item")
                            .foregroundColor(.secondary)
                    }
                }

                if selectedItem != nil {
                    Picker("Unit Type", selection: $selectedPriceMode) {
                        ForEach(priceModesForSelectedItem, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Text("Unit Price:")
                        Spacer()
                        Text(String(format: "$%.2f", currentUnitPrice))
                            .bold()
                    }

                    HStack {
                        Text("Line Total:")
                        Spacer()
                        Text(String(format: "$%.2f", currentLineTotal))
                            .bold()
                    }
                }

                TextField("Quantity", text: $quantityText)
                    .keyboardType(.decimalPad)

                PrimaryButton(title: "Add Line") {
                    addLineItem()
                }
                .disabled(selectedItem == nil || (Double(quantityText) ?? 0) <= 0)
            }

            Section(header: Text("Line Items")) {
                if receiptViewModel.tempLineItems.isEmpty {
                    Text("No items added.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(receiptViewModel.tempLineItems.enumerated()), id: \.offset) { index, entry in
                        VStack(alignment: .leading) {
                            Text(entry.item.name ?? "Item")

                            Text(String(
                                format: "%.2f × $%.2f (%@)",
                                entry.quantity,
                                entry.unitPrice,
                                entry.priceMode
                            ))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeLineItems)
                }
            }

            Section(header: Text("Totals")) {
                Text(String(format: "Subtotal: $%.2f", receiptViewModel.computeSubtotal()))
                Text(String(format: "Tax: $%.2f", receiptViewModel.computeTax()))
                Text(String(format: "Total: $%.2f", receiptViewModel.computeTotal()))
                    .bold()
            }
        }

        .navigationTitle("New Receipt")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    receiptViewModel.createReceipt()
                    dismiss()
                }
                .disabled(receiptViewModel.tempLineItems.isEmpty)
            }
        }

        .onAppear {
            clientViewModel.loadClients()
            itemViewModel.loadItems()
        }
    }

    private var currentClientLabel: String {
        receiptViewModel.selectedClient?.businessName ?? "None"
    }

    private func addLineItem() {
        guard let item = selectedItem,
              let qty = Double(quantityText),
              qty > 0 else { return }

        receiptViewModel.addTempLineItem(
            item: item,
            priceMode: selectedPriceMode,
            unitPrice: currentUnitPrice,
            quantity: qty
        )

        quantityText = "1"
    }

    private func removeLineItems(at offsets: IndexSet) {
        receiptViewModel.tempLineItems.remove(atOffsets: offsets)
    }
}
