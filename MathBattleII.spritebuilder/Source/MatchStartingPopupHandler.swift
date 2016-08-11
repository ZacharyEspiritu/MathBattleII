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
    
    func displayPopup(withHeader header: String, player1: String, player2: String) {
        displayPopup(withHeader: header, player1: player1, player2: player2, duration: 5)
    }
    
    func displayPopup(withHeader header: String, player1: String, player2: String, duration: Int) {
        popup = CCBReader.load("MatchStartingPopup") as! MatchStartingPopup
        popup.setHeaderLabel(string: header)
        popup.setInfoLabel(string: generateInfoString(withPlayer1: player1, player2: player2))
        popup.setCountdownLabel(string: "\(duration)")
        delegate?.shouldDisplayPopup(popup)
        startCountdown(withDuration: duration)
    }
    
    private func generateInfoString(withPlayer1 player1: String, player2: String) -> String {
        var infoString: String = "\(player1) vs \(player2)"
        
        if player1.characters.count >= 9 {
            infoString = player1.substringToIndex(player1.startIndex.advancedBy(7)) + "..."
        }
        else {
            infoString = player1
        }
        
        infoString = infoString + " vs "
        
        if player2.characters.count >= 9 {
            infoString = infoString + player2.substringToIndex(player2.startIndex.advancedBy(7)) + "..."
        }
        else {
            infoString = infoString + player2
        }
        
        return infoString
    }
    
    private func startCountdown(withDuration duration: Int) {
        countdown = duration
        NSTimer.schedule(repeatInterval: 1, handler: { timer in
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
        TransitionHandler.startTransition(outgoingSceneAnimated: false, incomingSceneAnimated: true, withCompletionHandler: { _ in
            let scene = CCScene()
            scene.addChild(CCBReader.load("GameplayScene") as! GameplayScene)
            let transition = CCTransition(crossFadeWithDuration: 0.5)
            transition.outgoingSceneAnimated = true
            CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        })
    }
}

protocol MatchStartingPopupHandlerDelegate {
    
    func shouldDisplayPopup(matchStartingPopup: MatchStartingPopup)
}