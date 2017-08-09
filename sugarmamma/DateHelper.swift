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
    
    init(_ format: String?) {
        if format != nil{
            formatter.dateFormat = format
        }
    }
    
    static func toString(_ dateInput: Date, dateFormat: String) -> String{
        let date = DateHelper(dateFormat)
        //date.formatter.timeZone = NSTimeZone(abbreviation: TimeZone.current.abbreviation()!)! as TimeZone
        return date.formatter.string(from: dateInput)
    }
    
    static func toDate(_ dateInput: String, dateFormat: String) -> Date? {
        let date = DateHelper(dateFormat)
        //date.formatter.timeZone = NSTimeZone(abbreviation: TimeZone.current.abbreviation()!)! as TimeZone
        return date.formatter.date(from: dateInput)
    }
    
    static func getTimezoneAbbreviation() -> String{
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "UTC" }
        return localTimeZoneAbbreviation
    }
    
}
