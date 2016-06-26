//
//  LeaderboardScrollViewCell.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/25/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LeaderboardScrollViewCell: CCNode {
    
    weak var rankingLabel, usernameLabel, ratingLabel: CCLabelTTF!
    
    func setData(ranking ranking: Int, username: String, rating: Int) {
        rankingLabel.string = "\(ranking)"
        
        if username.characters.count > 16 {
            usernameLabel.string = "\(username.substringToIndex(username.startIndex.advancedBy(9)))..."
        }
        else {
            usernameLabel.string = username
        }
        
        ratingLabel.string = "\(rating)"
    }
}