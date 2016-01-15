//
//  MainDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainDisplay: CCSprite {
    
    weak var topPlayerNameLabel, bottomPlayerNameLabel, timerLabel: CCLabelTTF!
    
    func didLoadFromCCB() {
        topPlayerNameLabel.string = "testset"
        bottomPlayerNameLabel.string = "Testasfsdf"
    }
}