//
//  KDCalendarHeaderView.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 07/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
    
    lazy var monthLabel : UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.center
        //lbl.font = UIFont(name: "SFDisplay-Text Medium", size: 30.00)
        lbl.font = lbl.font.withSize(25)
        //lbl.font.familyName = "SFDisplay-Text Medium"
        lbl.textColor = GlobalVariables.charcol
        
        self.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var dayLabelContainerView : UIView = {
        
        let v = UIView()
        
        let formatter : DateFormatter = DateFormatter()
        
        for index in 1...7 {
            
            let day : NSString = formatter.weekdaySymbols[index % 7] as NSString
            
            let weekdayLabel = UILabel()
            
            //weekdayLabel.font = UIFont(name: "SFDisplay-Text Medium", size: 14.0)
            weekdayLabel.font = weekdayLabel.font.withSize(13.0)
            
            
            weekdayLabel.text = day.substring(to: 3).uppercased()
            weekdayLabel.textColor = UIColor.gray
            weekdayLabel.textAlignment = NSTextAlignment.center
            
            v.addSubview(weekdayLabel)
        }
        
        self.addSubview(v)
        
        return v
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var frm = self.bounds
        frm.origin.y += 5.0
        frm.size.height = 40.0
        
        self.monthLabel.frame = frm
        
        
        var labelFrame = CGRect(x: 0.0, y: self.bounds.size.height / 2.0, width: self.bounds.size.width / 7.0, height: self.bounds.size.height / 2.0)
        
        for lbl in self.dayLabelContainerView.subviews {
            
            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
        
        
        
    }
    
}
