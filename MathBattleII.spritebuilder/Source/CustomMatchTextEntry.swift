//
//  CustomMatchTextEntry.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/21/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CustomMatchTextEntry: CCNode {
    
    weak var matchNameTextField: CCTextField!
    weak var matchPasswordTextField: CCTextField!
    
    func didLoadFromCCB() {
        let textFields = [matchNameTextField.textField, matchPasswordTextField.textField]
        for textField in textFields {
            
        }
    }
}