//
//  AnalyticsHelper.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 8/8/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class AnalyticsHelper: NSObject {
    
    static func notifyScreen(_ screenName: String){
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    static func notifyEvent(category: String, action: String, label: String){
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as! [AnyHashable : Any]!)
    }

}
