//
//  StoneLedgerApp.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import FirebaseCore
import CoreData
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct StoneLedgerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let persistenceController = PersistenceController.shared
 
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var clientViewModel: ClientViewModel
    @StateObject private var itemViewModel: ItemViewModel
    @StateObject private var receiptViewModel: ReceiptViewModel

    init() {
        let context = persistenceController.container.viewContext
        _clientViewModel = StateObject(wrappedValue: ClientViewModel(context: context))
        _itemViewModel = StateObject(wrappedValue: ItemViewModel(context: context))
        _receiptViewModel = StateObject(wrappedValue: ReceiptViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)
                .environmentObject(clientViewModel)
                .environmentObject(itemViewModel)
                .environmentObject(receiptViewModel)
        }
    }
}
