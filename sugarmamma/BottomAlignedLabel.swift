//
//  BottomAlignedLabel.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 26/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

@IBDesignable
class BottomAlignedLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        let height = self.sizeThatFits(rect.size).height - 4
        let y = rect.origin.y + rect.height - height - 4
        super.drawText(in: CGRect(x: rect.origin.x + 4, y: y, width: rect.width, height: height))
    }
}
