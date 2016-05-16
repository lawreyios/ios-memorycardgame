//
//  CMMainBoardCollectionViewController.swift
//  ColourMemory
//
//  Created by Lawrence Tan on 14/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

let kCardBgImageName = "card_bg"
private let reuseIdentifier = "CMCardCell"

class CMMainBoardCollectionViewController: UICollectionViewController {
    
    let kDelayTimeInSeconds = Double(1)
    let kCorrectPoints = 2
    let kIncorrectPoints = -1
    let kMaxPairOfCards = Int(8)
    
    weak var alertConfirmButton: UIAlertAction?
    
    let cmCardDealer: CMCardDealerManager = CMCardDealerManager.sharedInstance()
    let cmfbClient: CMFBClient = CMFBClient.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        startRandomPlacementOfDecks()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CMMainBoardCollectionViewController.resetGame(_:)), name: "ResetGameNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CMMainBoardCollectionViewController.applyResults(_:)), name: "CheckMatchNotification", object: nil)
    }
    
    func startRandomPlacementOfDecks() {
        cmCardDealer.createDeckOfCards()        
        collectionView?.reloadData()
    }
    

    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if Device.IS_5_5_INCHES_OR_LARGER() {
            return CGSizeMake(100, 130)
        }else if Device.IS_4_7_INCHES_OR_LARGER() {
            return CGSizeMake(90, 120)
        }
        return CGSizeMake(76, 95)
    }
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! CMHeaderView
            headerView.backgroundColor = UIColor(red: 241/255, green: 240/255, blue: 233/255, alpha: 1.0)
            headerView.lblScore.text = "Score : \(cmCardDealer.currentScore)"
            reusableview = headerView
        }
        return reusableview
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(kMaxPairOfCards*2) // 0-15
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CMCardCollectionViewCell
        
        let cardImage = UIImage(named: cmCardDealer.currentActiveDeck[indexPath.row].imageName!)
        cell.cardImageView.image = cardImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cmCardDealer.selectCard(cmCardDealer.currentActiveDeck[indexPath.row], idx: indexPath.row)
        collectionView.reloadData()
    }
    
    //MARK: TextField Configuration for Alert Controller
    
    func showEndGameSubmissionAlertView() {
        let alertController = UIAlertController(title: "Congratulations!\nYour score is \(cmCardDealer.currentScore)!", message: "Please input name:", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
                CMFBClient.submitNewScoreToServer(field.text!, score: self.cmCardDealer.currentScore)
                self.showHighScoreBoard()
            } else {
                // user did not fill field
            }
        }
        
        alertConfirmButton = confirmAction
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CMMainBoardCollectionViewController.handleTextFieldTextDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: textField)
        }
        
        alertController.addAction(confirmAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        alertConfirmButton!.enabled = textField.text?.characters.count >= 1
    }
    
    //MARK: Actions
    
    @IBAction func onHighScore(sender: AnyObject) {
        showHighScoreBoard()
    }
    
    func showHighScoreBoard() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CMHighScoresTableViewControllerNav") as! UINavigationController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func resetGame(notification: NSNotification) {
        cmCardDealer.resetGame()
        startRandomPlacementOfDecks()
    }
    
    func applyResults(notification: NSNotification) {
        switch cmCardDealer.result {
        case 3:
            showEndGameSubmissionAlertView()
            break
            
        default:
            collectionView!.reloadData()
        }
    }
}
