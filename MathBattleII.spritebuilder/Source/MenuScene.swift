//
//  MenuScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MenuScene: CCNode {
    
    weak var topAreaGroupingNode, centerAreaGroupingNode, largeButtonGroupingNode, smallButtonGroupingNode: CCNode!
    weak var largeMenuButton, leftMenuButton, centerMenuButton, rightMenuButton: CCButton!
    weak var newsButton, infoButton, leaderboardButton, gameCenterButton: CCButton!
    
    weak var levelDisplay: LevelDisplay!
    weak var coinDisplay: CoinDisplay!
    
    weak var menuGroupingNode: CCNode!
    weak var menuTintColorNode: CCNodeColor!
    
    weak var descriptionButton: CCButton!
    
    var currentMenuType: MenuType = .Ranked {
        didSet {
            loadMenuForType(type: currentMenuType)
        }
    }
    
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        currentMenuType = .Ranked
        self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
    }
    
    func leftButtonPressed() {
        currentMenuType = .CustomTextEntry
        self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
    }
    
    func centerButtonPressed() {
        currentMenuType = .Local
        self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
    }
    
    func rightButtonPressed() {
        currentMenuType = .Practice
        self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
    }
    
    func showDescription() {
        let descriptionPopup = CCBReader.load("DescriptionPopup") as! DescriptionPopup
        descriptionPopup.positionType = CCPositionTypeMake(CCPositionUnit.Points, CCPositionUnit.Points, CCPositionReferenceCorner.TopRight)
        descriptionPopup.position = CGPoint(x: 10, y: 177)
        descriptionPopup.loadDescriptionForMenu(menu: "RankedMatch")
        
        descriptionPopup.scale = 0
        self.addChild(descriptionPopup)
        descriptionPopup.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.3, scale: 1)))
    }
    
    // MARK: Data Functions
    
    private func loadMenuForType(type menuType: MenuType) {
        let menu: CCNode!
        switch menuType {
        case .Ranked:
            menu = CCBReader.load("RankedMatchMenu") as! RankedMatchMenu
            largeMenuButton.label.string = "Ranked Match"
            menuTintColorNode.color = CCColor(red: 245/255, green: 166/255, blue: 35/255)
        case .CustomOverview:
            menu = CCBReader.load("CustomMatchMenu") as! CustomMatchMenu
            largeMenuButton.label.string = "Custom Match"
            menuTintColorNode.color = CCColor(red: 126/255, green: 211/255, blue: 33/255)
        case .CustomTextEntry:
            menu = CCBReader.load("CustomMatchMenu") as! CustomMatchMenu
            (menu as! CustomMatchMenu).matchMenuType = .Join
            largeMenuButton.label.string = "Custom Match"
            menuTintColorNode.color = CCColor(red: 126/255, green: 211/255, blue: 33/255)
        case .Local:
            menu = CCBReader.load("LocalMatchMenu") as! LocalMatchMenu
            largeMenuButton.label.string = "Local Match"
            menuTintColorNode.color = CCColor(red: 80/255, green: 227/255, blue: 194/255)
        case .Practice:
            menu = CCBReader.load("LocalMatchMenu") as! LocalMatchMenu
            largeMenuButton.label.string = "Practice Match"
            menuTintColorNode.color = CCColor(red: 248/255, green: 231/255, blue: 28/255)
        }
        
        menu.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.TopLeft)
        menu.position = CGPoint(x: 0.5, y: 0.5)
        menu.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
        menu.contentSize = CGSizeMake(1, 1)
        
        menuGroupingNode.removeAllChildren()
        menuGroupingNode.addChild(menu)
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
            if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                levelDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
            else if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                coinDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if levelDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    print("touchLevelDisplay")
                }
            }
            levelDisplay.stopAllActions()
            levelDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
        
        if coinDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    print("touchCoinDisplay")
                }
            }
            coinDisplay.stopAllActions()
            coinDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
    }
    
    func segueToMainScene() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}

enum MenuType: String {
    case Ranked = "Ranked"
    case CustomOverview = "CustomOverview"
    case CustomTextEntry = "CustomTextEntry"
    case Local = "Local"
    case Practice = "Practice"
}