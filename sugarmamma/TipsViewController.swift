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
        ["playlist_id": "PL5rsyLxwQpVhCvBe8ZCVzyQwh7af-fYhW", "title": "Sugarbudget App"],
        ["playlist_id": "PL5rsyLxwQpVgDuz3K6rHq4J-iZM6qPQJd", "title": "App Tips"],
        ["playlist_id": "PL5rsyLxwQpVg0ztouQ8qxG1VI8LSGtF4j", "title": "General"],
        ["video_id": "3vg00xL3qBQ", "title": "How to Manage Your Accounts, Cashflow, Savings & Be Debt Free!"],
        ["video_id": "yrgI2irRulY", "title": "Top 5 Golden Rules for Investing & Building Wealth"],
        ["video_id": "tQoVROOXTkE", "title": "How and Why You Should Build on Solid Foundations for Wealth"],
        ["video_id": "xmhSgtPLlt4", "title": "Minimalism and Money"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Dashboard Tips & Tips")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UITableViewAutomaticDimension + CGFloat(25))
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "TipsPlaylistTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TipsPlaylistTableViewCell
        cell.tipsPlaylistTitle.text = videos[indexPath.row]["title"]
        if videos[indexPath.row]["playlist_id"] != nil{
            cell.youtubePlayer.loadPlaylistID(videos[indexPath.row]["playlist_id"]!)
            /*cell.youtubePlayer.playerVars = [
                "playsinline": "1" as AnyObject,
                "controls": "0" as AnyObject,
                "showinfo": "0" as AnyObject
            ]*/
        }else{
            cell.youtubePlayer.loadVideoID(videos[indexPath.row]["video_id"]!)
        }
        return cell
    }
    
}
