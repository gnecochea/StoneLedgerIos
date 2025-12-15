//
//  ReceiptDetailView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ReceiptDetailView: View {
    let receipt: Receipt

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                itemsSection
                totalsSection
            }
            .padding()
        }
        .navigationTitle("Receipt Detail")
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(DateUtils.format(receipt.date))
                .font(.headline)

            Text("Client: \(clientLabel)")
            Text("Sale Type: \(receipt.saleType ?? "-")")
            Text("Payment: \(receipt.paymentType ?? "-")")
            Text("Status: \(receipt.status ?? "-")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }

    private var itemsSection: some View {
        let items = (receipt.items as? Set<ReceiptItem> ?? []).sorted {
            $0.receiptItemId?.uuidString ?? "" < $1.receiptItemId?.uuidString ?? ""
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text("Items")
                .font(.headline)

            if items.isEmpty {
                Text("No items.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(items, id: \.objectID) { ri in
                    VStack(alignment: .leading) {
                        Text(itemLabel(for: ri))
                            .font(.subheadline)
                        Text(quantityPriceLabel(for: ri))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        if let data = ri.imageData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                        }
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
    }

    private var totalsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Subtotal: \(String(format: "$%.2f", receipt.subtotal))")
            Text("Tax: \(String(format: "$%.2f", receipt.tax))")
            Text("Total: \(String(format: "$%.2f", receipt.total))")
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }

    private var clientLabel: String {
        if let client = receipt.client {
            return client.businessName ?? "Client"
        }
        if let backup = receipt.clientNameBackup, !backup.isEmpty {
            return "\(backup) (deleted)"
        }
        return "Client (deleted)"
    }

    private func itemLabel(for ri: ReceiptItem) -> String {
        if let item = ri.item {
            return item.name ?? "Item"
        }
        if let backup = ri.itemNameBackup, !backup.isEmpty {
            return "\(backup) (deleted)"
        }
        return "Item (deleted)"
    }


    private func quantityPriceLabel(for ri: ReceiptItem) -> String {
        let qty = ri.quantity
        let unitPrice = ri.unitPrice
        let priceMode = ri.priceMode ?? ""
        return String(format: "%.2f x $%.2f (%@)", qty, unitPrice, priceMode)
    }
}
