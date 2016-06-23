//
//  CustomMatchMessageHeader.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CustomMatchMessageHeader: CCNode {
    
    weak var message: CCLabelTTF!
    
    func setMessage(string string: String) {
        message.string = string
    }
}