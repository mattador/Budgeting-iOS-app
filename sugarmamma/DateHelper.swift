//
//  DateFormatter.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 7/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    var formatter = DateFormatter()
    
    init(_ format: String) {
        formatter.dateFormat = format
    }
    
    static func toString(_ dateInput: Date, dateFormat: String) -> String{
        let date = DateHelper(dateFormat)
        return date.formatter.string(from: dateInput)
    }
    
    static func toDate(_ dateInput: String, dateFormat: String) -> Date? {
        let date = DateHelper(dateFormat)
        return date.formatter.date(from: dateInput)
    }
    
}
