//
//  MatchStartingPopupHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchStartingPopupHandler {
    
    static let sharedInstance = MatchStartingPopupHandler()
    private init() {}
    
    var delegate: MatchStartingPopupHandlerDelegate?
    
    var countdown: Int = 5
    var popup: MatchStartingPopup!
    
    func displayPopup(withHeader header: String, info: String) {
        popup = CCBReader.load("MatchStartingPopup") as! MatchStartingPopup
        popup.setHeaderLabel(string: header)
        popup.setInfoLabel(string: info)
        popup.setCountdownLabel(string: "5")
        delegate?.shouldDisplayPopup(popup)
        startCountdown()
    }
    
    private func startCountdown() {
        countdown = 5
        NSTimer.schedule(repeatInterval: 1, handler: { timer in
            print(self.countdown)
            self.countdown -= 1
            self.popup.setCountdownLabel(string: "\(self.countdown)")
            self.playCountdownSound()
            if self.countdown <= 0 {
                self.beginGame()
                timer.invalidate()
            }
        })
    }
    
    private func playCountdownSound() {
        OALSimpleAudio.sharedInstance().playEffect("ding.wav")
    }
    
    private func beginGame() {
        let scene = CCScene()
        scene.addChild(CCBReader.load("GameplayScene") as! GameplayScene)
        let transition = CCTransition(crossFadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}

protocol MatchStartingPopupHandlerDelegate {
    
    func shouldDisplayPopup(matchStartingPopup: MatchStartingPopup)
}