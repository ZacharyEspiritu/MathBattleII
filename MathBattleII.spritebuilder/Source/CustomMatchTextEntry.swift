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
            // textField.delegate = self
            textField.clipsToBounds = true
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 8.0
            textField.returnKeyType = .Next
            textField.autocapitalizationType = .None
            textField.autocorrectionType = .No
            textField.spellCheckingType = .No
            textField.clearButtonMode = .Never
        }
    }
    
    func getMatchName() -> String {
        return matchNameTextField.string
    }
    
    func getMatchPassword() -> String {
        return matchPasswordTextField.string
    }
}

extension CustomMatchTextEntry: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == matchNameTextField.textField {
            matchPasswordTextField.textField.becomeFirstResponder()
        }
        return false
    }
}