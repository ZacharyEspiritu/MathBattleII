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
    
    func loadDescriptionForMenu(menu menu: MenuType) {
        switch menu {
        case .Ranked:
            setDescription(description: "Battle other players in a race\nto solve five puzzles as fast\nas possible!\n\nYou win BattlePoints by\nwinning matches, but you can\nalso lose them!")
        case .Custom:
            setDescription(description: "Setup an online match with a\nfriend by entering the same room\nname and password!")
        case .Local:
            setDescription(description: "Play on the same device\nagainst a friend!")
        case .Practice:
            setDescription(description: "Practice your match skills by\nattempting to solve as many\npuzzles as you can in 90\nseconds!")
        default:
            assertionFailure()
        }
    }
    
    private func setDescription(description popupString: String) {
        label.string = popupString
        
        self.contentSize = CGSize(width: label.contentSize.width + 28, height: label.contentSize.height + 38)
        label.position = CGPoint(x: 14.0, y: 23.0)
    }
}