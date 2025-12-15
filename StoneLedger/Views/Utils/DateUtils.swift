//
//  DateUtils.swift
//  StoneLedger
//
//  Created by csuftitan
//

import Foundation
import Combine

enum DateUtils {
    static let displayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    static func format(_ date: Date?) -> String {
        guard let date else { return "-" }
        return displayFormatter.string(from: date)
    }
}
