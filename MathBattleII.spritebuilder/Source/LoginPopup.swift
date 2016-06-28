//
//  LoginPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/27/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopup: CCNode {
    
    weak var background: CCSprite9Slice!
    weak var detailButton, mainButton: CCButton!
    
    let loginViewHeight: CGFloat = 137
    let registrationViewHeight: CGFloat = 233
    
    let animationConstant: CGFloat = 10
    
    var currentLoginView: LoginView = .Login
    
    
    func detailButtonPressed() {
        toggleView()
    }
    
    func mainButtonPressed() {
        
    }
    
    private func toggleView() {
        if currentLoginView == .Login {
            currentLoginView = .Registration
        }
        else {
            currentLoginView = .Login
        }
    }
    
    override func update(delta: CCTime) {
        if currentLoginView == .Login && self.contentSize.height > loginViewHeight {
            self.contentSize.height -= animationConstant
            if self.contentSize.height < loginViewHeight {
                self.contentSize.height = loginViewHeight
            }
        }
        else if currentLoginView == .Login && self.contentSize.height < registrationViewHeight {
            self.contentSize.height += animationConstant
            if self.contentSize.height > registrationViewHeight {
                self.contentSize.height = registrationViewHeight
            }
        }
    }
}

enum LoginView {
    case Login
    case Registration
}