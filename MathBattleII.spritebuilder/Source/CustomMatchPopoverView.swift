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
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: CustomMatchPopoverViewDelegate? = nil
    
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
    
    @IBAction func cancelMatchCreation() {
        delegate?.viewNeedsToBeRemoved(self)
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

protocol CustomMatchPopoverViewDelegate {
    func viewNeedsToBeRemoved(view: CustomMatchPopoverView)
}