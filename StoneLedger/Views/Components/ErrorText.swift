//
//  ErrorText.swift
//  StoneLedger
//
//  Created by csuftitan
//

import SwiftUI
import Combine

struct ErrorText: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.footnote)
            .foregroundColor(.red)
            .padding(.top, 4)
    }
}

