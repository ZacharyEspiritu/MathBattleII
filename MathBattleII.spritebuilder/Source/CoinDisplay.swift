//
//  CoinDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/1/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CoinDisplay: CCNode {
    
    weak var background: CCSprite!
    weak var displayIcon: CCSprite!
    weak var addButton: CCButton!
    
    weak var coinLabel: CCLabelTTF!
    var coins: Int = 0
    
    
    func didLoadFromCCB() {
        loadData()
    }
    
    func loadData() {
        if let user = UserManager.sharedInstance.getCurrentUser() {
            coins = user.getCoins()
            self.coinLabel.string = "\(coins)"
        }
    }
    
    func addButtonPressed() {
        
    }
}