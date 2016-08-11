//
//  UserManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 2/11/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserManager {
    
    static let sharedInstance = UserManager()
    private init() {}
    
    private var currentUser: User?
    
    
    // MARK: Functions
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func setCurrentUser(newUser: User) throws {
        guard currentUser == nil else {
            throw UserManagerError.UserAlreadyExists
        }
        currentUser = newUser
    }
    
    func removeCurrentUser() throws {
        guard let _ = currentUser else {
            throw UserManagerError.CurrentUserDoesNotExist
        }
        currentUser = nil
    }
}

enum UserManagerError: ErrorType {
    case CurrentUserDoesNotExist
    case UserAlreadyExists
}