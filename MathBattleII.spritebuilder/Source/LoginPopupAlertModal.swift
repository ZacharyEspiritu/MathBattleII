//
//  LoginPopupAlertModal.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/2/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopupAlertModal: CCNode {
    
    weak var alertLabel: CCLabelTTF!
    
    let defaultPosition = CGPoint(x: 0.5, y: 65)
    var timer: NSTimer?
    
    func displayAlert() {
        timer?.invalidate()
        timer = nil
        stopAllActions()
        self.position = defaultPosition
        self.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0.5, y: 0))))
        timer = NSTimer.schedule(delay: 7, handler: { _ in
            self.runAction(CCActionEaseSineIn(action: CCActionMoveTo(duration: 0.3, position: self.defaultPosition)))
        })
    }
    
    func setAlert(string string: String) {
        alertLabel.string = string
    }
}