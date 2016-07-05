//
//  MenuDisplayManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/4/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MenuDisplayManager {
    
    static let sharedInstance = MenuDisplayManager()
    
    var coinDisplay: CoinDisplay?
    var levelDisplay: LevelDisplay?
    var rankedPlayerHeader: RankedPlayerHeader?
    
    var coins: Int {
        didSet {
            coinDisplay?.loadData()
        }
    }
    var experienceLevel: Int {
        didSet {
            levelDisplay?.loadData()
        }
    }
    
    
    // MARK: Listener Functions
    
    private init() {
        coins = UserManager.sharedInstance.getCurrentUser() != nil ? UserManager.sharedInstance.getCurrentUser()!.getCoins() : 0
        experienceLevel = UserManager.sharedInstance.getCurrentUser() != nil ? UserManager.sharedInstance.getCurrentUser()!.getExperienceLevel() : 0
    }
    
    func attachToCoinDisplay(coinDisplay coinDisplay: CoinDisplay) {
        self.coinDisplay = coinDisplay
    }
    
    func attachToLevelDisplay(levelDisplay levelDisplay: LevelDisplay) {
        self.levelDisplay = levelDisplay
    }
    
    func attachToRankedPlayerHeader(rankedPlayerHeader: RankedPlayerHeader) {
        self.rankedPlayerHeader = rankedPlayerHeader
    }
    
    // MARK: Update Functions
    
    func updateCoinDisplays(coins newCoins: Int) {
        coins = newCoins
    }
    
    func updateLevelDisplays(experienceLevel newExperienceLevel: Int) {
        experienceLevel = newExperienceLevel
    }
    
    func updateRankedPlayerHeader() {
        rankedPlayerHeader?.updateHeaderData()
    }
}