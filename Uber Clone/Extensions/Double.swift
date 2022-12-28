//
//  Double.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/28/22.
//

import Foundation

// Create an extension on a Double in order to convert it to a currency for our pricing model.
extension Double {
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
}
