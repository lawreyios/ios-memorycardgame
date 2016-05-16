//
//  CMFBClient.swift
//  ColourMemory
//
//  Created by 2359 Lawrence on 16/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import Foundation
import Firebase

class CMFBClient : NSObject {
    
    // MARK: Properties
    var myRootRef = Firebase(url:CMFBClient.Constants.myRootRefUrl+CMFBClient.Constants.playersEndPoint)
    var playerScores = [PlayerScore]()
    
    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        //Firebase.defaultConfig().persistenceEnabled = true
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> CMFBClient {
        
        struct Singleton {
            static let sharedInstance = CMFBClient()
        }
        
        return Singleton.sharedInstance
    }
    
    class func submitNewScoreToServer(name: String, score: Int) {
        let data: [String : AnyObject] = [
            "name" : name,
            "score" : score
        ]
        let dataRef = CMFBClient.sharedInstance().myRootRef.childByAppendingPath(name)
        dataRef.setValue(data)
    }
    
    class func getHighScoresFromServer(completionHandler: (hasResult: Bool, error: NSError?) -> Void) {
        CMFBClient.sharedInstance().playerScores.removeAll()
        CMFBClient.sharedInstance().myRootRef.observeEventType(.Value, withBlock: { snapshot in
            
            if let json = snapshot.value as? NSDictionary {
                for (key, value) in json {
                    if let value = value as? NSDictionary {
                        CMFBClient.sharedInstance().playerScores.append(PlayerScore(name: key as! String, score: value["score"] as! Int))
                        print("The \(key)'s score is \(value["score"]!)")
                    }
                }
                
                //Sort Higest to Lowest
                CMFBClient.sharedInstance().playerScores.sortInPlace ({
                    return $0.score > $1.score
                })
                return completionHandler(hasResult: true, error: nil)
            }
            return completionHandler(hasResult: false, error: nil)
        })
    }
    
}