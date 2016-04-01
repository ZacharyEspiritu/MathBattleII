//
//  RankedMatchPlayerHeader.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/1/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RankedPlayerHeader: CCNode {
    
    weak var background: CCSprite!
    weak var usernameLabel: CCLabelTTF!
    weak var rankingLabel: CCLabelTTF!
    
    func didLoadFromCCB() {
        if let user = UserManager.sharedInstance.getCurrentUser() {
            usernameLabel.string = user.getDisplayName()
            rankingLabel.string = "\(user.getRating())"
        }
        else {
            usernameLabel.string = "No User Available"
            rankingLabel.string = "Log In"
        }
    }
    
}