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
    let kPoints = 2
    let kMaxPairOfCards = Int(8)
    
    var currentActiveDeck = [Card]()
    
    var currentActiveChosenCards = [Card]()
    var currentActiveChosenCardsIdx = [Int]()
    var currentScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startRandomPlacementOfDecks()
    }
    
    func startRandomPlacementOfDecks() {
        
        createDeckOfCards()
        collectionView?.reloadData()
    }
    
    func createDeckOfCards() {
        var numberOfTimes = 0
        while numberOfTimes < 2 {
            var currentNumberOfPairs = 0
            while currentNumberOfPairs < kMaxPairOfCards {
                let newCard = Card(value: currentNumberOfPairs+1)
                currentActiveDeck.append(newCard)
                currentNumberOfPairs+=1
            }
            numberOfTimes+=1
        }
        currentActiveDeck.shuffle()
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
            headerView.lblScore.text = "Score : \(currentScore)"
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
        
        let cardImage = UIImage(named: currentActiveDeck[indexPath.row].imageName!)
        cell.cardImageView.image = cardImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if currentActiveChosenCards.count == 0 || currentActiveChosenCards.count == 1 {
            var chosenCard = currentActiveDeck[indexPath.row]
            currentActiveChosenCards.append(chosenCard)
            currentActiveChosenCardsIdx.append(indexPath.row)
            if !chosenCard.flipped {
                chosenCard.imageName = "colour\(chosenCard.value!)"
                chosenCard.flipped = true
                currentActiveDeck[indexPath.row] = chosenCard
                if currentActiveChosenCards.count == 2 {
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(kDelayTimeInSeconds * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        if self.checkIfMatch() {
                            self.currentScore+=self.kPoints
                            self.currentActiveChosenCardsIdx.removeAll()
                            self.currentActiveChosenCards.removeAll()
                            self.collectionView!.reloadData()
                        }else{
                            self.resetCardImages()
                        }
                    }
                }
            }
            collectionView.reloadData()
        }
    }
    
    func checkIfMatch() -> Bool {
        let firstCard = currentActiveChosenCards[0]
        let secondCard = currentActiveChosenCards[1]
        if firstCard.value == secondCard.value {
            return true
        }
        return false
    }
    
    func resetCardImages() {
        var firstCard = currentActiveDeck[currentActiveChosenCardsIdx[0]]
        var secondCard = currentActiveDeck[currentActiveChosenCardsIdx[1]]
        firstCard.flipped = false
        firstCard.imageName = kCardBgImageName
        currentActiveDeck[currentActiveChosenCardsIdx[0]] = firstCard
        secondCard.flipped = false
        secondCard.imageName = kCardBgImageName
        currentActiveDeck[currentActiveChosenCardsIdx[1]] = secondCard
        currentActiveChosenCardsIdx.removeAll()
        currentActiveChosenCards.removeAll()
        collectionView!.reloadData()
    }
}
