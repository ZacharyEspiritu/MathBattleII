//
//  CustomMatchMenuButtons.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 5/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CustomMatchMenuButtons: CCNode {
    
    weak var joinButton: CCButton!
    weak var createButton: CCButton!
    
    var delegate: CustomMatchMenuButtonsDelegate?
    
    func joinButtonPressed() {
        delegate?.joinButtonPressed()
    }
    
    func createButtonPressed() {
        delegate?.createButtonPressed()
    }
}

protocol CustomMatchMenuButtonsDelegate {
    func joinButtonPressed()
    func createButtonPressed()
}