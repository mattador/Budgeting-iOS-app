//
//  KDCalendarDayCell.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 02/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit

let cellColorDefault = GlobalVariables.calendarDayGrey
let cellColorToday = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.3)

class CalendarDayCell: UICollectionViewCell {
    
    var eventsCount = 0 {
        didSet {
            for sview in self.dotsView.subviews {
                sview.removeFromSuperview()
            }
            if eventsCount == 0{
                return
            }
            let frameWidth = Int(self.frame.size.width)
            if eventsCount < 5{
                for c in 0..<eventsCount {
                    let frm = CGRect(x: 0, y: (c * 8) + (c + 1), width: frameWidth - 10, height: 8)
                    let rectangle = UIView(frame: frm)
                    rectangle.backgroundColor = GlobalVariables.pastelYellow
                    self.dotsView.addSubview(rectangle)
                }
            }else{
                let columnsCanFit: Int = Int(Double((frameWidth) / 15).rounded()) - 1
                //print("CAN FIT \(columnsCanFit) ITEMS")
                var rowCount: Int = 0
                var columnCount: Int = 0
                for c in 0..<eventsCount {
                    if c > 9{
                        break
                    }
                    let frm = CGRect(x: (12 * columnCount) + 3, y: (12 * rowCount) + 3, width: 10, height: 10)
                    let circle = UIView(frame: frm)
                    circle.layer.cornerRadius = CGFloat(5)
                    circle.backgroundColor = GlobalVariables.pastelYellow
                    self.dotsView.addSubview(circle)
                    if columnCount < columnsCanFit{
                        columnCount = columnCount + 1
                    }else{
                        columnCount = 0
                        rowCount = rowCount + 1
                    }
                    
                    
                }
            }
        }
    }
    
    var isToday : Bool = false {
        didSet {
            if isToday == true {
                self.pBackgroundView.backgroundColor = GlobalVariables.pastelGreen
            }
            else {
                self.pBackgroundView.backgroundColor = cellColorDefault
            }
        }
    }
    
    override var isSelected : Bool {
        
        didSet {
            
            if isSelected == true {
                //self.pBackgroundView.layer.borderWidth = 2.0
                
            }
            else {
                //self.pBackgroundView.layer.borderWidth = 0.0
            }
            
        }
    }
    
    lazy var pBackgroundView : UIView = {
        
        var vFrame = self.frame.insetBy(dx: 2.0, dy: 2.0)
        
        let view = UIView(frame: vFrame)
        
        view.layer.cornerRadius = 0.0
        
        //view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 0.0
        
        view.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        
        view.backgroundColor = GlobalVariables.calendarDayGrey
        
        
        return view
    }()
    
    lazy var textLabel : UILabel = {
        
        let lbl = BottomAlignedLabel()
        
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = GlobalVariables.charcol
        lbl.textAlignment = .left
        //lbl.layer.borderColor = UIColor.red.cgColor
        //lbl.layer.borderWidth = 2.0
        lbl.font = UIFont(name: "SFDisplay-Text Medium", size: CGFloat(12))
        
        
        return lbl
        
    }()
    
    lazy var dotsView : UIView = {
        
        let frm = CGRect(
            origin: CGPoint(x: 4, y: 4),
            size: self.frame.size
        )
        let dv = UIView(frame: frm)
        return dv
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        self.addSubview(self.pBackgroundView)
        
        self.textLabel.frame = self.bounds
        //textLabel.font = UIFont(name: "SFDisplay-Text Medium", size: CGFloat(12))
        textLabel.font = textLabel.font.withSize(13)
        self.addSubview(self.textLabel)
        
        self.addSubview(dotsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
