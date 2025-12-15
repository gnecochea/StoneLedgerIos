//
//  ReceiptsListView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ReceiptsListView: View {
    @EnvironmentObject var receiptViewModel: ReceiptViewModel

    var body: some View {
        List {
            if receiptViewModel.receipts.isEmpty {
                Text("No receipts yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(receiptViewModel.receipts, id: \.objectID) { receipt in
                    NavigationLink {
                        ReceiptDetailView(receipt: receipt)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(DateUtils.format(receipt.date))
                                .font(.headline)
                            HStack {
                                Text(clientLabel(for: receipt))
                                Spacer()
                                Text(String(format: "$%.2f", receipt.total))
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                            Text("\(itemCount(for: receipt)) items")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteReceipts)
            }
        }
        .navigationTitle("Receipts")
    }

    private func deleteReceipts(at offsets: IndexSet) {
        offsets.map { receiptViewModel.receipts[$0] }.forEach { receipt in
            receiptViewModel.deleteReceipt(receipt)
        }
    }

    private func clientLabel(for receipt: Receipt) -> String {
        if receipt.client == nil {
            return "No / Deleted Client"
        }
        return receipt.client?.businessName ?? "Client"
    }

    private func itemCount(for receipt: Receipt) -> Int {
        let set = receipt.items as? Set<ReceiptItem> ?? []
        return set.count
    }
}
