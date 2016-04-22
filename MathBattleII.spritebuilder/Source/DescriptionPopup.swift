//
//  DescriptionPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class DescriptionPopup: CCNode {
    
    weak var sprite: CCSprite9Slice!
    weak var label: CCLabelTTF!
    
    func loadDescriptionForMenu(menu menu: String) {
        switch menu {
        case "RankedMatch":
            setDescription(description: "Battle other players in a race to solve five puzzles as fast as possible!\n\nYou win BattlePoints by winning matches, but you can also lose them!")
        default:
            assertionFailure()
        }
    }
    
    private func setDescription(description desciption: String) {
        label.string = description
    }
}