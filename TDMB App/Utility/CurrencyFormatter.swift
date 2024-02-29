//
//  CurrencyFormatter.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 24.06.2022.
//

import Foundation


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
