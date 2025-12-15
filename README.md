## Goals of the Project

The goal of the project was to create an application for keeping track of receipts at my father’s store. Currently, receipts are written by hand, but managing them digitally has the potential to be much faster and simpler. The shop requires something very intuitive and unusually flexible, but the current prototype is close to reaching that goal.

## Functionalities

- Saving clients with multiple attributes
- Creating items with multiple attributes and pricing modes
- Creating receipts composed of multiple items and connected to a client

## Architecture and Design

This project uses the Model–View–ViewModel (MVVM) architecture.
- The View layer is located under the Views folder and is further divided by feature area, such as authentication (Auth), managing clients (Clients), managing receipts (Receipts), and shared UI components.
- The Model layer is defined through Core Data and consists of four entities: Client, Item, Receipt, and ReceiptItem. Relationships are established between these entities, such as the one-to-many relationship between clients and receipts, and between receipts and receipt items.
- The ViewModel layer is split between the Repositories and ViewModels folders. Repositories directly access the database through Core Data operations, while ViewModels contain the business logic and application state, merely observed by the SwiftUI views for the sake of isolation between the UI and internal logic.

Finally, the Navigation layer is responsible for directing users through the application based on authentication state, using Firebase Authentication to determine whether the user should see the login flow or the main application.

## Deployment Instructions

- Clone the repository using Xcode
- Run the project (all required files are included)
