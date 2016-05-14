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
    
    let kPoints = 2
    let kMaxPairOfCards = UInt32(8)
    
    var currentActiveDeck = [Card]()
    var cardUpperDeck = [String]()
    var cardLowerDeck = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        startRandomPlacementOfDecks()
    }
    
    func startRandomPlacementOfDecks() {
        
        cardUpperDeck = setupCardPhotosInRandomOrder()
        cardLowerDeck = setupCardPhotosInRandomOrder()
    }

    
    func setupCardPhotosInRandomOrder() -> [String] {
        
        var newCardImagesDeck = [String]()
        var generatedNumbers = [Int]()
        var counter = UInt32(0)
        
        var newGeneratedNumber = Int(arc4random_uniform(kMaxPairOfCards)) + 1
        while counter < kMaxPairOfCards {
            if !generatedNumbers.contains(newGeneratedNumber){
                generatedNumbers.append(newGeneratedNumber)
                counter+=1
                let newCard = Card(value: newGeneratedNumber)
                let randomCardImageFilename = "colour\(newGeneratedNumber)"
                newCardImagesDeck.append(randomCardImageFilename)
                currentActiveDeck.append(newCard)
                
            }else{
                newGeneratedNumber = Int(arc4random_uniform(kMaxPairOfCards)) + 1
            }
        }
        return newCardImagesDeck
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
            headerView.lblScore.text = "Score : 0"
            reusableview = headerView
        }
        return reusableview
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(kMaxPairOfCards*2) // 0-17
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CMCardCollectionViewCell
        
        let cardImage = UIImage(named: currentActiveDeck[indexPath.row].imageName!)
        cell.cardImageView.image = cardImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var chosenCard = currentActiveDeck[indexPath.row]
        if !chosenCard.flipped {
            if indexPath.row < 8 {
                chosenCard.imageName = cardLowerDeck[indexPath.row]
                chosenCard.flipped = true
                currentActiveDeck[indexPath.row] = chosenCard
            }else{
                let idx = indexPath.row - 8
                chosenCard.imageName = cardUpperDeck[idx]
                chosenCard.flipped = true
                currentActiveDeck[indexPath.row] = chosenCard
            }
        }else{
            chosenCard.flipped = false
            chosenCard.imageName = kCardBgImageName
            currentActiveDeck[indexPath.row] = chosenCard
        }
        collectionView.reloadData()
    }
}
