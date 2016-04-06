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
    var coins: Int = 0 {
        didSet {
            coinLabel.string = "\(coins)"
        }
    }
    
    
    func didLoadFromCCB() {
        loadData()
    }
    
    private func loadData() {
        if let user = UserManager.sharedInstance.getCurrentUser() {
            coins = user.getCoins()
        }
    }
    
    private func animateCoinCount() {
        var currentCoinCount: Int = 0
        NSTimer.schedule(repeatInterval: 0.001, handler: { timer in
            currentCoinCount += 1
            self.coinLabel.string = "\(currentCoinCount)"
            if currentCoinCount >= self.coins {
                self.coinLabel.string = "\(self.coins)"
                timer.invalidate()
            }
        })
    }
}