//
//  CMHighScoresTableViewController.swift
//  ColourMemory
//
//  Created by 2359 Lawrence on 16/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

class CMHighScoresTableViewController: UITableViewController {
    
    let cmfbAgent: CMFBClient = CMFBClient.sharedInstance()
    var playersScores = [PlayerScore]()
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        let nib = UINib(nibName: "CMSectionHeaderView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CMSectionHeaderView")
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "Hall of Fame"
        CMFBClient.getHighScoresFromServer { (hasResult, error) in
            if hasResult {
                dispatch_async(dispatch_get_main_queue(), {
                    self.playersScores = CMFBClient.sharedInstance().playerScores
                    self.tableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                })
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersScores.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CMPlayerScoreTableViewCell") as! CMPlayerScoreTableViewCell
        let currPlayerScore = playersScores[indexPath.row]
        cell.lblRank.text = "\(indexPath.row+1)."
        cell.lblName.text = "\(currPlayerScore.name!)"
        cell.lblScore.text = String(currPlayerScore.score!)
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("CMSectionHeaderView")
        return cell
    }
    
    @IBAction func onClose(sender: AnyObject) {
        dismissViewControllerAnimated(true) { 
            NSNotificationCenter.defaultCenter().postNotificationName("ResetGameNotification", object: nil)
        }
    }
    

}
