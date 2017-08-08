//
//  Helper.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 25/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import Foundation

//beta versioning
let CURRENT_VERSION = 1.43
let BUILD_VERSION = 0.46

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

//Global variables
struct GlobalVariables {
    static let borderGrey = UIColor.rbg(r: 204, g: 204, b: 204)
    static let lightTextGrey = UIColor.rbg(r: 204, g: 209, b: 217)
    static let ultraLightGrey = UIColor.rbg(r: 247, g: 247, b: 247)
    static let white = UIColor.rbg(r: 255, g: 255, b: 255)
    static let purple = UIColor.rbg(r: 157, g: 133, b: 190)
    static let charcol = UIColor.rbg(r: 67, g: 74, b: 84)
    static let darkGreen = UIColor.rbg(r: 3, g: 145, b: 27)
    static let pastelGreen = UIColor.rbg(r: 160, g: 222, b: 210)
    static let strongYellow = UIColor.rbg(r: 254, g: 219, b: 119)
    static let pinkRed = UIColor.rbg(r: 255, g: 88, b: 121)
    static let pastelYellow = UIColor.rbg(r: 252, g: 219, b: 119)
    static let calendarDayGrey = UIColor.rbg(r: 245, g: 247, b: 249)
    static let buttonTextGrey = UIColor.rbg(r: 95, g: 94, b: 95)
    
    
    static func createBlurView(_ view: UIView) -> UIVisualEffectView{
        //add blurry background
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurVisualEffectView
    }
    
    static func randomString(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func getIndexPathRelativeToUIView(_ prototypeCellElement: UIView, recursionLimit: Int = 5) -> IndexPath?{
        //traverse through view structure to find indexPath, as alternative to setting in element .tag attribute
        var cellReference = prototypeCellElement
        var cell: UITableViewCell? = nil
        for _ in 1 ... recursionLimit{
            let classType = String(describing: type(of: cellReference))
            //print( classType)
            if classType.hasSuffix("TableViewCell"){
                cell = cellReference as? UITableViewCell
                break
            }
            cellReference = cellReference.superview!
        }
        if cell != nil{
            var tableReference = cell!.superview
            var table: UITableView
            for _ in 1 ... 5{
                if  (tableReference?.isKind(of: UITableView.classForCoder()))! {
                    table = tableReference as! UITableView
                    if let indexPath = table.indexPath(for: cell!){
                        return indexPath
                    }
                }
                tableReference = tableReference?.superview
            }
        }
        return nil
    }
    
}

