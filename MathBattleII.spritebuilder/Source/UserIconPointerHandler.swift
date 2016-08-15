//
//  UserIconPointerHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 8/14/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserIconPointerHandler {
    
    static let sharedInstance = UserIconPointerHandler()
    
    var userIconPointer: UserIconPointer?
    
    func attachToUserIconPointer(userIconPointer userIconPointer: UserIconPointer) {
        self.userIconPointer = userIconPointer
    }
    
    func displayPointer() {
        userIconPointer?.triggerAnimationSequence()
    }
}