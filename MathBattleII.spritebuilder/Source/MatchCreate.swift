//
//  MatchCreate.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchCreate: CCNode {
    
    weak var matchName: CCTextField!
    weak var password: CCTextField!
    
    func create() {
        Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName.string, customPassword: password.string)
    }
    
    func join() {
        showPopup()
        //Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName.string, password: password.string)
    }
    
    func menu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func showPopup() {
        let mainView = CCDirector.sharedDirector().view
        
        let popover = NSBundle.mainBundle().loadNibNamed("CustomMatchPopoverView", owner: self, options: nil)[0] as! CustomMatchPopoverView
        popover.frame = CGRectMake(0, 0, 275, 188)
        popover.center = CGPointMake(mainView.frame.size.width / 2, mainView.frame.size.height / 2)
        popover.clipsToBounds = true
        
        popover.layer.cornerRadius = 10.0
        popover.layer.shadowColor = UIColor.blackColor().CGColor
        popover.layer.shadowOffset = CGSizeZero
        popover.layer.shadowRadius = 5.0
        popover.layer.shadowOpacity = 0.5
        popover.layer.masksToBounds = true
        
        mainView.addSubview(popover)
    }
}

class CustomMatchPopoverView: UIView {
    
    @IBOutlet weak var lobbyNameTextField: TextEntryField!
    @IBOutlet weak var lobbyPasswordTextField: TextEntryField!
    
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

class TextEntryField: UITextField, UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string as NSString).rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).location != NSNotFound {
            return false
        }
        return true
    }
}

extension String {
    func containsOnlyAlphanumericCharacters() -> Bool {
        for character in self.characters {
            if (!(character >= "a" && character <= "z") && !(character >= "A" && character <= "Z") && !(character >= "0" && character <= "9")) {
                return false
            }
        }
        return true
    }
}

enum MatchType {
    case Ranked, Unranked, CustomUnranked, Local
}