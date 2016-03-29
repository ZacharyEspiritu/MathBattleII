//
//  String+AlphanumericChecker.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

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