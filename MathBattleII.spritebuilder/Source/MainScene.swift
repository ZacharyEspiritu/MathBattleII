//
//  MenuScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation
import GameKit

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
    
    weak var userIconPointer: UserIconPointer!
    
    weak var shopGroupingNode: CCNode!
    var shopIsDisplaying: Bool = false {
        didSet {
            if shopIsDisplaying {
                displayShop()
            }
            else {
                removeShop()
            }
        }
    }
    
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
        MenuDisplayManager.sharedInstance.attachToCoinDisplay(coinDisplay: coinDisplay)
        MenuDisplayManager.sharedInstance.attachToLevelDisplay(levelDisplay: levelDisplay)
        UserIconPointerHandler.sharedInstance.attachToUserIconPointer(userIconPointer: userIconPointer)
        
        NSTimer.schedule(delay: 1, handler: { timer in
            let application = UIApplication.sharedApplication()
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            timer.invalidate()
        })
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
        FIRAnalytics.logEventWithName("news_view_opened", parameters: nil)
    }
    
    func infoButtonPressed() {
        segueToNewDataView(withButtonPressed: .Info)
        FIRAnalytics.logEventWithName("info_view_opened", parameters: nil)
    }
    
    func leaderboardButtonPressed() {
        segueToNewDataView(withButtonPressed: .Leaderboard)
        FIRAnalytics.logEventWithName("leaderboard_view_opened", parameters: nil)
    }
    
    func gameCenterButtonPressed() {
        showLeaderboard()
        FIRAnalytics.logEventWithName("game_center_opened", parameters: nil)
    }
    
    func userIconPressed() {
        if let user = UserManager.sharedInstance.getCurrentUser() {
            UserPopupHandler.displayUserPopup(forUser: user)
            
            FIRAnalytics.logEventWithName("login_modal_displayed", parameters: [
                "current_user": user.getDisplayName()
            ])
        }
        else {
            LoginPopupHandler.displayLoginPopup()
            
            FIRAnalytics.logEventWithName("login_modal_displayed", parameters: nil)
        }
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
        
        levelDisplay.hideDescriptionPopup()
        
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
            break
        default:
            largeMenuButton.label.string = "Choose A Mode:"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        }
        
        if let view = dataView {
            view.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.TopLeft)
            view.position = CGPoint(x: 0.5, y: 0.5)
            view.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
            view.contentSize = CGSizeMake(1, 1)
            
            menuGroupingNode.removeAllChildren()
            dataViewGroupingNode.removeAllChildren()
            dataViewGroupingNode.addChild(view)
            userInteractionEnabled = true
        }
    }
    
    private func segueToNewMenu(withButtonPressed buttonPressed: MenuButtonType) {
        let buttonIndex = buttonPressed.rawValue        // Main = 0, Left = 1, Center = 2, Right = 3
        let currentMenuIndex = currentMenuType.rawValue // None = -1, Ranked = 0, Custom = 1, Local = 2, Practice = 3
        var newMenuIndex = (currentMenuIndex < 0) ? buttonIndex : (buttonIndex + currentMenuIndex) % 4
        
        switch buttonIndex {
        case 0:
            newMenuIndex = -1
        case 1:
            newMenuIndex = 1
        case 2:
            newMenuIndex = 2
        case 3:
            newMenuIndex = 3
        default:
            assertionFailure("Impossible buttonIndex found!")
        }
        
        if currentMenuIndex == newMenuIndex || newMenuIndex == -1 {
            if newMenuIndex != -1 || currentMenuIndex != -1 {
                currentMenuType = .None
                self.animationManager.runAnimationsForSequenceNamed("BackToMainMenu")
            }
        }
        else if let newMenuType = MenuType(rawValue: newMenuIndex) {
            currentMenuType = newMenuType
            self.animationManager.runAnimationsForSequenceNamed("ToGamemodeMenu")
        }
        
        currentDescriptionPopup?.removeFromParent()
        currentDescriptionPopup = nil
        
        levelDisplay.hideDescriptionPopup()
        
        if newMenuIndex != -1 || currentMenuIndex != -1 {
            OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        }
    }
    
    private func loadMenuForType(type menuType: MenuType) {
        var gamemodeMenu: CCNode? = nil
        switch menuType {
        case .Ranked:
            gamemodeMenu = CCBReader.load("RankedMatchMenu") as! RankedMatchMenu
            (gamemodeMenu as! RankedMatchMenu).delegate = self
            menuTintColorNode.color = CCColor(red: 245/255, green: 166/255, blue: 35/255)
            largeMenuButton.label.string = "Ranked Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        case .Custom:
            gamemodeMenu = CCBReader.load("CustomMatchMenu") as! CustomMatchMenu
            menuTintColorNode.color = CCColor(red: 126/255, green: 211/255, blue: 33/255)
            largeMenuButton.label.string = "Custom Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        case .Local:
            gamemodeMenu = CCBReader.load("LocalMatchMenu") as! LocalMatchMenu
            menuTintColorNode.color = CCColor(red: 80/255, green: 227/255, blue: 194/255)
            largeMenuButton.label.string = "Local Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        case .Practice:
            gamemodeMenu = CCBReader.load("PracticeMatchMenu") as! PracticeMatchMenu
            menuTintColorNode.color = CCColor(red: 248/255, green: 231/255, blue: 28/255)
            largeMenuButton.label.string = "Practice Match"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        default:
            largeMenuButton.label.string = "Choose A Mode:"
            leftMenuButton.label.string = "Custom"
            centerMenuButton.label.string = "Local"
            rightMenuButton.label.string = "Practice"
        }
        
        if let menu = gamemodeMenu {
            menu.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.TopLeft)
            menu.position = CGPoint(x: 0.5, y: 0.5)
            menu.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
            menu.contentSize = CGSizeMake(1, 1)
            
            dataViewGroupingNode.removeAllChildren()
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
            else {
                levelDisplay.hideDescriptionPopup()
                if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    coinDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
                }
            }
        }
        else {
            levelDisplay.hideDescriptionPopup()
        }
        
        currentDescriptionPopup?.removeFromParent()
        currentDescriptionPopup = nil
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if levelDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    levelDisplay.displayDescriptionPopup()
                    removeShop()
                    
                    FIRAnalytics.logEventWithName("level_popup_displayed", parameters: nil)
                }
            }
            levelDisplay.stopAllActions()
            levelDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
        
        if coinDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    shopIsDisplaying = shopIsDisplaying ? false : true
                }
            }
            coinDisplay.stopAllActions()
            coinDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
    }
    
    private func displayShop() {
        let shop = CCBReader.load("ShopPopup") as! ShopPopup
        shop.contentSizeType = CCSizeType(widthUnit: .Normalized, heightUnit: .Normalized)
        shop.contentSize = CGSize(width: 1, height: 1)
        shop.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .TopLeft)
        shop.position = CGPoint(x: 0.5, y: 0.5)
        shop.delegate = self
        shopGroupingNode.addChild(shop)
        
        FIRAnalytics.logEventWithName("shop_opened", parameters: nil)
    }
    
    private func removeShop() {
        shopGroupingNode.removeAllChildren()
        
        FIRAnalytics.logEventWithName("shop_closed", parameters: nil)
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

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        let viewController = CCDirector.sharedDirector().parentViewController!
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainScene: ShopPopupDelegate {
    
    func focusOutAreaTouched(shopPopup: ShopPopup) {
        shopIsDisplaying = false
    }
}

extension MainScene: RankedMatchMenuDelegate {
    
    func rankingsButtonPressed(rankedMatchMenu: RankedMatchMenu) {
        currentMenuType = .None
        segueToNewDataView(withButtonPressed: .Leaderboard)
    }
    
    func activityLogButtonPressed(rankedMatchMenu: RankedMatchMenu) {
        currentMenuType = .None
        segueToNewDataView(withButtonPressed: .News)
    }
    
    func achievementsButtonPressed(rankedMatchMenu: RankedMatchMenu) {
        showLeaderboard()
    }
    
    func infoButtonPressed(rankedMatchMenu: RankedMatchMenu) {
        currentMenuType = .None
        segueToNewDataView(withButtonPressed: .Info)
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