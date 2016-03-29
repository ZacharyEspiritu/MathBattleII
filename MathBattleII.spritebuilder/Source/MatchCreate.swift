//
//  MatchCreate.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchCreate: CCNode {
    
    weak var matchName: CCTextField!
    weak var password: CCTextField!
    
    func create() {
        Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName.string, customPassword: password.string)
    }
    
    func join() {
        showPopup()
        //Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName.string, password: password.string)
    }
    
    func menu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func showPopup() {
        let mainView = CCDirector.sharedDirector().view
        
        let popover = NSBundle.mainBundle().loadNibNamed("CustomMatchPopoverView", owner: self, options: nil)[0] as! CustomMatchPopoverView
        popover.frame = CGRectMake(0, 0, 275, 188)
        popover.center = CGPointMake(mainView.frame.size.width / 2, mainView.frame.size.height / 2)
        popover.clipsToBounds = true
        
        popover.layer.cornerRadius = 10.0
        popover.layer.shadowColor = UIColor.blackColor().CGColor
        popover.layer.shadowOffset = CGSizeZero
        popover.layer.shadowRadius = 5.0
        popover.layer.shadowOpacity = 0.5
        popover.layer.masksToBounds = true
        
        mainView.addSubview(popover)
    }
}