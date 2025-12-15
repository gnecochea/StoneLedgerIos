//
//  ClientsFormView.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine
import CoreData

struct ClientFormView: View {
    @EnvironmentObject var clientViewModel: ClientViewModel
    @Environment(\.dismiss) private var dismiss

    var clientToEdit: Client? = nil

    @State private var businessName: String = ""
    @State private var ownerName: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var sellerPermit: String = ""
    @State private var notes: String = ""

    var isEditing: Bool {
        clientToEdit != nil
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Info")) {
                TextField("Business Name", text: $businessName)
                TextField("Owner Name", text: $ownerName)
            }

            Section(header: Text("Contact")) {
                TextField("Phone", text: $phone)
                TextField("Address", text: $address)
            }

            Section(header: Text("Details")) {
                TextField("Seller Permit", text: $sellerPermit)
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .navigationTitle(isEditing ? "Edit Client" : "New Client")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") { saveClient() }
                    .disabled(businessName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear {
            if let c = clientToEdit {
                businessName = c.businessName ?? ""
                ownerName = c.ownerName ?? ""
                phone = c.phone ?? ""
                address = c.address ?? ""
                sellerPermit = c.sellerPermit ?? ""
                notes = c.notes ?? ""
            }
        }
    }

    private func saveClient() {
        if let existing = clientToEdit {
            existing.businessName = businessName
            existing.ownerName = ownerName
            existing.phone = phone
            existing.address = address
            existing.sellerPermit = sellerPermit
            existing.notes = notes
            clientViewModel.updateClient(existing)
        } else {
            clientViewModel.addClient(
                businessName: businessName,
                ownerName: ownerName.isEmpty ? nil : ownerName,
                phone: phone.isEmpty ? nil : phone,
                address: address.isEmpty ? nil : address,
                sellerPermit: sellerPermit.isEmpty ? nil : sellerPermit,
                notes: notes.isEmpty ? nil : notes
            )
        }
        dismiss()
    }
}
