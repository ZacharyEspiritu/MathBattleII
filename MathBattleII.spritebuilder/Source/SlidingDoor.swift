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
    
    /**
     Triggers the `SlidingDoor` open animation.
     */
    func openDoors() {
        self.animationManager.runAnimationsForSequenceNamed("OpenDoors")
    }
    
    /**
     Triggers the `SlidingDoor` close animation.
     */
    func closeDoors() {
        self.animationManager.runAnimationsForSequenceNamed("CloseDoors")
    }
}