//
//  CMCardDealerManager.swift
//  ColourMemory
//
//  Created by 2359 Lawrence on 16/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import Foundation

let kDelayTimeInSeconds = Double(1)
let kCorrectPoints = 2
let kIncorrectPoints = -1
let kMaxPairOfCards = Int(8)

class CMCardDealerManager {
    
    //Card Cards Result
    var result = 0
    
    //Current Game Variables
    var currentActiveDeck = [Card]()
    var currentActiveChosenCards = [Card]()
    var currentActiveChosenCardsIdx = [Int]()
    var currentScore = 0
    var currentPairsFlipped = 0
    
    static let singleton = CMCardDealerManager()
    
    class func sharedInstance() -> CMCardDealerManager {
        return singleton
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
    
    func selectCard(card: Card, idx: Int) {
        if currentActiveChosenCards.count == 0 || currentActiveChosenCards.count == 1 {
            var chosenCard = currentActiveDeck[idx]
            currentActiveChosenCards.append(chosenCard)
            currentActiveChosenCardsIdx.append(idx)
            if !chosenCard.flipped {
                chosenCard.imageName = "colour\(chosenCard.value!)"
                chosenCard.flipped = true
                currentActiveDeck[idx] = chosenCard
                if currentActiveChosenCards.count == 2 {
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(kDelayTimeInSeconds * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.checkCards()
                    }
                }
            }
        }
    }
    
    // Card Result :
    // 0 - First Card, Do Nothing, reload
    // 1 - Second Card, Matched, Score, reload
    // 2 - Second Card, MisMatch, Minus Score, reload
    // 3 - Last Pair, Game End
    
    func checkCards() {
        if self.checkIfMatch() {
            self.currentScore+=kCorrectPoints
            self.currentPairsFlipped+=1
            self.currentActiveChosenCardsIdx.removeAll()
            self.currentActiveChosenCards.removeAll()
            result = 1
        }else{
            self.currentScore+=kIncorrectPoints
            self.flipBackBothCards()
            result = 2
        }
        if self.checkIfGameShouldEnd() {
            result = 3
            NSNotificationCenter.defaultCenter().postNotificationName("CheckMatchNotification", object: nil)
            return
        }
        
        result = 0
        NSNotificationCenter.defaultCenter().postNotificationName("CheckMatchNotification", object: nil)
    }
    
    func checkIfMatch() -> Bool {
        let firstCard = currentActiveChosenCards[0]
        let secondCard = currentActiveChosenCards[1]
        if firstCard.value == secondCard.value {
            return true
        }
        return false
    }
    
    func checkIfGameShouldEnd() -> Bool {
        if currentPairsFlipped == kMaxPairOfCards {
            return true
        }
        return false
    }
    
    func flipBackBothCards() {
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
    }
    
    func resetGame() {
        currentActiveDeck = [Card]()
        currentActiveChosenCards = [Card]()
        currentActiveChosenCardsIdx = [Int]()
        currentScore = 0
        currentPairsFlipped = 0
        
    }
}