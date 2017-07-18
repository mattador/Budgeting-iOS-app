//
//  TipsViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 23/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//
//TipsViewController
import UIKit

class TipsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var videos: [[String:String]] = [
        ["url": "https://www.youtube.com/embed/4seTt5NU-rs", "title": "HOW TO: BUDGET YOUR MONEY!", "description": "I've been getting a bunch of requests on how I budget my money in college, so I decided to share some tips with you all about budgeting!"],
        ["url": "https://www.youtube.com/embed/qLAuuIKBW4U","title": "10 Budget Tips That I Live By","description": "The less \"stuff\" I buy, the more money I save. The more money I save, the more time I gain. The more time I gain, the more days/weeks I have to travel and enjoy more of what life has to offer! :)"],
        ["url": "https://www.youtube.com/embed/TkTfKI3qtz8",
         "title": "5 Easy Budgeting Tips: Back to Budget Basics",
         "description": "Click here to check out other awesome budgeting videos from the Kin Back to Budge Basics Collaboration"],
        ["url": "https://www.youtube.com/embed/fwZ8pvmlQEk","title": "How to Budget When You're Broke","description": "Budgeting doesn’t come easy for all of us, and it’s an even bigger pain when you’re broke af. Here’s how to budget your money when you don’t have much in the first place."]
        
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "TipsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TipsTableViewCell
        
        cell.TipsDescription.text = videos[indexPath.row]["description"]
        cell.TipsLabel.text = videos[indexPath.row]["title"]
        let url = URL(string: videos[indexPath.row]["url"]!)
        cell.TipsVIdeo.loadRequest(URLRequest(url: url!))
        return cell
    }
    
}
