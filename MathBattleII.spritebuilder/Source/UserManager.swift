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
    
    private var currentUser: User!
    
    
    func getCurrentUser() throws -> User {
        guard let user = currentUser else {
            throw UserManagerError.CurrentUserDoesNotExist
        }
        return user
    }
    
    func setCurrentUser(newUser: User) throws {
        guard currentUser == nil else {
            throw UserManagerError.UserAlreadyExists
        }
        currentUser = newUser
        print(currentUser)
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