//
//  SlidingDoor.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/24/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class SlidingDoor: CCNode {
    
    weak var label: CountdownDisplay!
    
    func openDoors() {
        self.animationManager.runAnimationsForSequenceNamed("OpenDoors")
    }
    
    func removeSelfFromParentNode() {
        self.removeFromParent()
    }
}