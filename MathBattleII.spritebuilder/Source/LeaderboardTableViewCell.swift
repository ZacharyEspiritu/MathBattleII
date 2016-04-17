//
//  LeaderboardTableViewCell.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/11/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var overallPlacing: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var ranking: UILabel!
    
    func setData(overallPlacing overallPlacing: Int, playerName: String, ranking: Int) {
        self.overallPlacing.text = "\(overallPlacing)"
        
        if playerName.characters.count > 16 {
            self.playerName.text = "\(playerName.substringToIndex(playerName.startIndex.advancedBy(15)))..."
        }
        else {
            self.playerName.text = playerName
        }
        
        self.ranking.text = "\(ranking)"
    }
}