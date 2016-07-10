//
//  TestingPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/10/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TestingPopup: CCNode {
    
    weak var focusOutButton: CCButton!
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
    }
    
    func closeButtonPressed() {
        TestingPopupHandler.hideTestingPopup()
    }
}