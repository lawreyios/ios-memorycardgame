//
//  CMMainBoardCollectionViewController.swift
//  ColourMemory
//
//  Created by Lawrence Tan on 14/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CMMainBoardCollectionViewController: UICollectionViewController {
    
    var cardImagesUpperDeck = [String]()
    var cardImagesLowerDeck = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        cardImagesUpperDeck = setupCardPhotosInRandomOrder()
        cardImagesLowerDeck = setupCardPhotosInRandomOrder()
        
    }
    
    func setupCardPhotosInRandomOrder() -> [String] {
        
        var newCardImagesDeck = [String]()
        var previousNumber: UInt32?
        
        func randomNumber() -> UInt32 {
            var randomNumber = arc4random_uniform(8)
            while previousNumber == randomNumber {
                randomNumber = arc4random_uniform(8)
            }
            previousNumber = randomNumber
            return randomNumber+1
        }
        
        for _ in 1 ..< 9 {
            let randomCardImageFilename = "colour\(randomNumber())"
            newCardImagesDeck.append(randomCardImageFilename)
        }
        return newCardImagesDeck
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
