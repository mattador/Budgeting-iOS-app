//
//  Currency.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 7/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class CurrencyHelper: NSObject {
    var formatter = NumberFormatter()
    var symbol: String
    
    init(_ currencySymbol: String, minFractionDigits: Int = 2, maxFractionDigits: Int = 2) {
        self.formatter.currencySymbol = ""
        self.formatter.minimumFractionDigits = minFractionDigits
        self.formatter.maximumFractionDigits = maxFractionDigits
        self.formatter.numberStyle = .currency
        self.symbol = currencySymbol
    }
    
    func beautify(_ price: Double) -> String {
        var isNegative: Bool = false
        if price < 0{
            isNegative = true
        }
        let str = self.formatter.string(from: NSNumber(value: price))!
        if isNegative{
            return "- " + self.symbol + str.replacingOccurrences(of: "-", with: "")
        }
        return self.symbol + str
    }
    
    // Following is just a helper method, you can customize/move/delete this method as per your app needs
    static func format(_ price: Double, currencyCode: String) -> String {
        return CurrencyHelper(currencyCode).beautify(price)
    }
}
