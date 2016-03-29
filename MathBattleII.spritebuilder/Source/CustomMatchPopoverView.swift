//
//  CustomMatchPopoverView.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

enum MatchType {
    case Ranked, Unranked, CustomUnranked, PracticeMode, Local
}

class CustomMatchPopoverView: UIView {
    
    @IBOutlet weak var lobbyNameTextField: UITextField!
    @IBOutlet weak var lobbyPasswordTextField: UITextField!
    
    @IBOutlet weak var createMatchButton: UIButton!
    
    
    @IBAction func createNewMatch() {
        guard let lobbyName = lobbyNameTextField.text else {
            return
        }
        guard let lobbyPassword = lobbyPasswordTextField.text else {
            return
        }
        
        if validateCustomMatchString(string: lobbyName) && validateCustomMatchString(string: lobbyPassword) {
            print("good")
        }
    }
    
    private func validateCustomMatchString(string string: String) -> Bool {
        if string.characters.count >= 5 {
            if string.containsOnlyAlphanumericCharacters() {
                return true
            }
        }
        return false
    }
}