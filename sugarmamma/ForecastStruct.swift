//
//  ForecastStruct.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 21/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

struct ForecastStruct{
    var label: String = ""
    var amount: Double = 0.0
    var category: String = ""
    var goalProgressBar: Double = 0.0 //for goal progress bar
    var goalLastMonthAndNotComplete: Bool = false //for goal in last month when not enough money has been raised
}
