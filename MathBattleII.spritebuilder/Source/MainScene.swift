//
//  MenuScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    weak var topAreaGroupingNode, centerAreaGroupingNode, largeButtonGroupingNode, smallButtonGroupingNode, bottomAreaGroupingNode: CCNode!
    weak var largeMenuButton, leftMenuButton, centerMenuButton, rightMenuButton: CCButton!
    weak var newsButton, infoButton, leaderboardButton, gameCenterButton: CCButton!
    
    weak var levelDisplay: LevelDisplay!
    weak var coinDisplay: CoinDisplay!
    
    weak var menuGroupingNode: CCNode!
    weak var menuTintColorNode: CCNodeColor!
    
    weak var dataViewGroupingNode: CCNode!
    
    weak var descriptionButton: CCButton!
    var currentDescriptionPopup: DescriptionPopup?
    
    weak var focusOut: CCSprite!
    
    var currentMenuType: MenuType = .None {
        didSet {
            loadMenuForType(type: currentMenuType)
        }
    }
    
    var currentDataView: DataViewButtonType = .None {
        didSet {
            loadDataViewForType(type: currentDataView)
        }
    }

    
    func didLoadFromCCB() {
        GameCenterInteractor.sharedInstance.authenticationCheck()
        MatchStartingPopupHandler.sharedInstance.delegate = self
    }
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        if currentDataView == .None {
            segueToNewMenu(withButtonPressed: .Main)
        }
        else {
            segueToNewDataView(withButtonPressed: .None)
        }
    }
    
    func leftButtonPressed() {
        segueToNewMenu(withButtonPressed: .Left)
    }
    
    func centerButtonPressed() {
        segueToNewMenu(withButtonPressed: .Center)
    }
    
    func rightButtonPressed() {
        segueToNewMenu(withButtonPressed: .Right)
    }
    
    func newsButtonPressed() {
        segueToNewDataView(withButtonPressed: .News)
        print("news")
        
    }
    
    func infoButtonPressed() {
        segueToNewDataView(withButtonPressed: .Info)
    }
    
    func leaderboardButtonPressed() {
        segueToNewDataView(withButtonPressed: .Leaderboard)
        
    }
    
    func gameCenterButtonPressed() {
        segueToNewDataView(withButtonPressed: .GameCenter)
        print("game center")
        
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        let scene = CCScene()
        scene.addChild(CCBReader.load("UserRegistrationScene") as! UserRegistrationScene)
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func showDescription() {
        if currentDescriptionPopup == nil {
            currentDescriptionPopup = CCBReader.load("DescriptionPopup") as? DescriptionPopup
            if let descriptionPopup = currentDescriptionPopup {
                descriptionPopup.positionType = CCPositionTypeMake(CCPositionUnit.Points, CCPositionUnit.Points, CCPositionReferenceCorner.TopRight)
                descriptionPopup.position = CGPoint(x: 10, y: 177)
                descriptionPopup.loadDescriptionForMenu(menu: currentMenuType)
                
                descriptionPopup.scale = 0
                self.addChild(descriptionPopup)
                descriptionPopup.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.3, scale: 1)))
            }
        }
        else {
            currentDescriptionPopup?.removeFromParent()
            currentDescriptionPopup = nil
        }
    }
    
    // MARK: Animation Callback Functions
    
    func removeCurrentMenu() {
        currentMenuType = .None
        menuGroupingNode.removeAllChildren()
    }
    
    func removeCurrentDataView() {
        currentDataView = .None
        dataViewGroupingNode.removeAllChildren()
    }
    
    // MARK: Data Functions
    
    private func segueToNewDataView(withButtonPressed buttonPressed: DataViewButtonType) {
        let buttonIndex = buttonPressed.rawValue        // News = 0, Info = 1, Leaderboard = 2, GameCenter = 3
        let currentDataViewIndex = currentDataView.rawValue // None = -1, Ranked = 0, Custom = 1, Local = 2, Practice = 3
        
        if buttonIndex == DataViewButtonType.None.rawValue || currentDataViewIndex == buttonIndex {
            currentDataView = .None
            self.animationManager.runAnimationsForSequenceNamed("BackToMainMenuFromDataView")
        }
        else if let newDataView = DataViewButtonType(rawValue: buttonIndex) {
            currentDataView = newDataView
            self.animationManager.runAnimationsForSequenceNamed("ToDataView")
        }
        
        currentDescriptionPopup?.removeFromParent()
        currentDescriptionPopup = nil
        
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    private func loadDataViewForType(type dataViewType: DataViewButtonType) {
        var dataView: CCNode? = nil
        switch dataViewType {
        case .News:
            dataView = CCBReader.load("NewsDataView") as! NewsDataView
            largeMenuButton.label.string = "News"
        case .Info:
            dataView = CCBReader.load("InfoDataView") as! InfoDataView
            largeMenuButton.label.string = "Info"
        case .Leaderboard:
            dataView = CCBReader.load("LeaderboardDataView") as! LeaderboardDataView
            largeMenuButton.label.string = "Leaderboard"
        case .GameCenter:
            print("Game Center")
        default:
            largeMenuButton.label.string = "Ranked Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        }
        
        if let view = dataView {
            view.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.TopLeft)
            view.position = CGPoint(x: 0.5, y: 0.5)
            view.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
            view.contentSize = CGSizeMake(1, 1)
            
            dataViewGroupingNode.removeAllChildren()
            dataViewGroupingNode.addChild(view)
            userInteractionEnabled = true
        }
    }
    
    private func segueToNewMenu(withButtonPressed buttonPressed: MenuButtonType) {
        let buttonIndex = buttonPressed.rawValue        // Main = 0, Left = 1, Center = 2, Right = 3
        let currentMenuIndex = currentMenuType.rawValue // None = -1, Ranked = 0, Custom = 1, Local = 2, Practice = 3
        let newMenuIndex = (currentMenuIndex < 0) ? buttonIndex : (buttonIndex + currentMenuIndex) % 4
        
        if currentMenuIndex == newMenuIndex {
            currentMenuType = .None
            self.animationManager.runAnimationsForSequenceNamed("BackToMainMenu")
        }
        else if let newMenuType = MenuType(rawValue: newMenuIndex) {
            currentMenuType = newMenuType
            self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
        }
        
        currentDescriptionPopup?.removeFromParent()
        currentDescriptionPopup = nil
        
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    private func loadMenuForType(type menuType: MenuType) {
        var gamemodeMenu: CCNode? = nil
        switch menuType {
        case .Ranked:
            gamemodeMenu = CCBReader.load("RankedMatchMenu") as! RankedMatchMenu
            menuTintColorNode.color = CCColor(red: 245/255, green: 166/255, blue: 35/255)
            largeMenuButton.label.string = "Ranked Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        case .Custom:
            gamemodeMenu = CCBReader.load("CustomMatchMenu") as! CustomMatchMenu
            menuTintColorNode.color = CCColor(red: 126/255, green: 211/255, blue: 33/255)
            largeMenuButton.label.string = "Custom Match"
            leftMenuButton.label.string = "Local"
            centerMenuButton.label.string = "Practice"
            rightMenuButton.label.string = "Ranked"
        case .Local:
            gamemodeMenu = CCBReader.load("LocalMatchMenu") as! LocalMatchMenu
            menuTintColorNode.color = CCColor(red: 80/255, green: 227/255, blue: 194/255)
            largeMenuButton.label.string = "Local Match"
            leftMenuButton.label.string = "Practice"
            centerMenuButton.label.string = "Ranked"
            rightMenuButton.label.string = "Custom"
        case .Practice:
            gamemodeMenu = CCBReader.load("PracticeMatchMenu") as! PracticeMatchMenu
            menuTintColorNode.color = CCColor(red: 248/255, green: 231/255, blue: 28/255)
            largeMenuButton.label.string = "Practice Match"
            leftMenuButton.label.string = "Ranked"
            centerMenuButton.label.string = "Custom"
            rightMenuButton.label.string = "Local"
        default:
            largeMenuButton.label.string = "Ranked Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        }
        
        if let menu = gamemodeMenu {
            menu.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.TopLeft)
            menu.position = CGPoint(x: 0.5, y: 0.5)
            menu.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
            menu.contentSize = CGSizeMake(1, 1)
            
            menuGroupingNode.removeAllChildren()
            menuGroupingNode.addChild(menu)
            userInteractionEnabled = true
        }
    }
    
    // MARK: Touch Functions
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
            if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                levelDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
            else if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                coinDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
        }
        
        currentDescriptionPopup?.removeFromParent()
        currentDescriptionPopup = nil
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
}

extension MainScene: MatchStartingPopupHandlerDelegate {
    
    func shouldDisplayPopup(matchStartingPopup: MatchStartingPopup) {
        focusOut.runAction(CCActionFadeTo(duration: 0.3, opacity: 1))
        matchStartingPopup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        matchStartingPopup.position = CGPoint(x: 0.5, y: 0.5)
        focusOut.addChild(matchStartingPopup)
    }
}


enum MenuType: Int {
    case None = -1
    case Ranked = 0
    case Custom = 1
    case Local = 2
    case Practice = 3
}

enum MenuButtonType: Int {
    case Main = 0
    case Left = 1
    case Center = 2
    case Right = 3
}

enum DataViewButtonType: Int {
    case None = -1
    case News = 0
    case Info = 1
    case Leaderboard = 2
    case GameCenter = 3
}