//
//  ReceiptViewModel.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct TempLineItem {
    let item: Item
    let priceMode: String
    let unitPrice: Double
    var quantity: Double
}

final class ReceiptViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var tempLineItems: [TempLineItem] = []

    @Published var selectedClient: Client? = nil
    @Published var paymentType: String = "CASH"
    @Published var saleType: String = "RETAIL"
    @Published var status: String = "FINALIZED"

    @Published var errorMessage: String? = nil

    private let context: NSManagedObjectContext
    private let receiptRepo: ReceiptRepository
    private let receiptItemRepo: ReceiptItemRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        self.receiptRepo = ReceiptRepository(context: context)
        self.receiptItemRepo = ReceiptItemRepository(context: context)

        loadReceipts()
    }

    func loadReceipts() {
        do {
            receipts = try receiptRepo.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addTempLineItem(item: Item, priceMode: String, unitPrice: Double, quantity: Double) {
        tempLineItems.append(
            TempLineItem(item: item, priceMode: priceMode, unitPrice: unitPrice, quantity: quantity)
        )
    }

    func removeTempLineItems(at offsets: IndexSet) {
        tempLineItems.remove(atOffsets: offsets)
    }

    func clearTemp() {
        tempLineItems.removeAll()
        selectedClient = nil
        paymentType = "CASH"
        saleType = "RETAIL"
        status = "FINALIZED"
    }

    // MARK: - Totals
    func computeSubtotal() -> Double {
        tempLineItems.reduce(0) { $0 + ($1.unitPrice * $1.quantity) }
    }

    func computeTax() -> Double {
        computeSubtotal() * 0.0875
    }

    func computeTotal() -> Double {
        computeSubtotal() + computeTax()
    }

    func createReceipt() {
        let newReceipt = Receipt(context: context)
        newReceipt.receiptId = UUID()
        newReceipt.date = Date()
        newReceipt.saleType = saleType
        newReceipt.paymentType = paymentType
        newReceipt.status = status
        newReceipt.subtotal = computeSubtotal()
        newReceipt.tax = computeTax()
        newReceipt.total = computeTotal()

        newReceipt.client = selectedClient
        newReceipt.clientNameBackup = selectedClient?.businessName

        // Create receipt items
        for entry in tempLineItems {
            let ri = ReceiptItem(context: context)
            ri.receiptItemId = UUID()
            ri.quantity = entry.quantity
            ri.priceMode = entry.priceMode
            ri.unitPrice = entry.unitPrice
            ri.imageData = entry.item.imageData
            ri.receipt = newReceipt

            ri.item = entry.item
            ri.itemNameBackup = entry.item.name
        }

        do {
            try context.save()
            loadReceipts()
            clearTemp()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteReceipt(_ receipt: Receipt) {
        do {
            try receiptRepo.delete(receipt)
            loadReceipts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
