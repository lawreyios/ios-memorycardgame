//
//  Card.swift
//  ColourMemory
//
//  Created by Lawrence Tan on 15/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import Foundation

struct Card {
    
    var imageName : String? = ""
    var value : Int? = 0
    var flipped : Bool = false
    
    init(value: Int){
        
        self.imageName = kCardBgImageName
        self.value = value
        self.flipped = false
        
    }
    
}