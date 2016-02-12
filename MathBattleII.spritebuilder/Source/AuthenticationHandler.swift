//
//  AuthenticationHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class AuthenticationHandler {
    
    static let sharedInstance = AuthenticationHandler()
    private init() {}
    
    var currentAuthenticationHandle: UInt!
    
    
    func listenForAuthenticationStateChange() {
        let ref = Firebase(url: Config.firebaseURL)
        let handle = ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                print(authData)
            } else {
                // No user is signed in
            }
        })
        
        ref.removeAuthEventObserverWithHandle(handle)
    }
    
    func checkImmediatelyIfUserIsAuthenticated() {
        let ref = Firebase(url: Config.firebaseURL)
        if ref.authData != nil {
            // user authenticated
            print(ref.authData)
        } else {
            // No user is signed in
        }
    }
    
    func authenticateUser(email email: String, password: String) {
        let ref = Firebase(url: Config.firebaseURL)
        ref.authUser(email, password: password,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // Something went wrong. :(
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            print("Handle invalid user")
                        case .InvalidEmail:
                            print("Handle invalid email")
                        case .InvalidPassword:
                            print("Handle invalid password")
                        default:
                            print("Handle default situation")
                        }
                    }
                }
                else {
                    // Authentication just completed successfully :)
                    // The logged in user's unique identifier
                    print(authData.uid)
                    
                    let userRef = Firebase(url: "\(Config.firebaseURL)/users/\(authData.uid)")
                    // Attach a closure to read the data at our posts reference
                    self.currentAuthenticationHandle = userRef.observeEventType(.Value, withBlock: { snapshot in
                        self.saveUserDataLocally(snapshot: snapshot)
                        },
                        withCancelBlock: { error in
                            print(error.description)
                    })
                }
        })
    }
    
    private func saveUserDataLocally(snapshot snapshot: FDataSnapshot!) {
        let displayName = snapshot.value.objectForKey("displayName") as! String
        let email = snapshot.value.objectForKey("email") as! String
        let numberOfGamesPlayed = snapshot.value.objectForKey("numberOfGamesPlayed") as! Int
        let numberOfWins = snapshot.value.objectForKey("numberOfWins") as! Int
        let numberOfLosses = snapshot.value.objectForKey("numberOfLosses") as! Int
        let provider = snapshot.value.objectForKey("provider") as! String
        let rating = snapshot.value.objectForKey("rating") as! Int
        let ratingFloor = snapshot.value.objectForKey("ratingFloor") as! Int
        let friends: [String]
        if snapshot.value.objectForKey("friends") != nil {
            friends = snapshot.value.objectForKey("friends") as! [String]
        }
        else {
            friends = []
        }
        
        let user = User(uid: snapshot.value.uid, displayName: displayName, email: email, provider: provider, numberOfGamesPlayed: numberOfGamesPlayed, numberOfWins: numberOfWins, numberOfLosses: numberOfLosses, rating: rating, ratingFloor: ratingFloor, friends: friends)
        let userManager = UserManager.sharedInstance
        
        do {
            try userManager.setCurrentUser(user)
            print("saving user good")
        }
        catch {
            print("saving user failed")
        }
        
        print(snapshot.value)
    }
    
    func changeDisplayName(newDisplayName newDisplayName: String) {
        let ref = Firebase(url: Config.firebaseURL)
        let authData = ref.authData
        
        let updatedUserData = [
            "provider": authData.provider,
            "displayName": newDisplayName
        ]
        
        // Create a child path with a key set to the uid underneath the "users" node
        // This creates a URL path like the following:
        //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        ref.childByAppendingPath("users")
            .childByAppendingPath(authData.uid).setValue(updatedUserData)
    }
    
    func logoutCurrentSession() {
        let ref = Firebase(url: Config.firebaseURL)
        let userRef = Firebase(url: "\(Config.firebaseURL)/users/\(ref.authData.uid)")
        userRef.removeAuthEventObserverWithHandle(currentAuthenticationHandle)
        ref.unauth()
    }
    
    func changeEmail(oldEmail oldEmail: String, newEmail: String, password: String) {
        let ref = Firebase(url: Config.firebaseURL)
        ref.changeEmailForUser(oldEmail, password: password, toNewEmail: newEmail,
            withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                } else {
                    // Email changed successfully
                }
        })
    }
    
    func changePassword(email email: String, oldPassword: String, newPassword: String) {
        let ref = Firebase(url: Config.firebaseURL)
        ref.changePasswordForUser(email, fromOld: oldPassword, toNew: newPassword,
            withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                } else {
                    // Password changed successfully
                }
        })
    }
    
    func sendResetPasswordEmail(forUserEmail email: String) {
        let ref = Firebase(url: Config.firebaseURL)
        ref.resetPasswordForUser(email, withCompletionBlock: { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Password reset sent successfully
            }
        })
    }
    
    func deleteUser(email email: String, password: String) {
        let ref = Firebase(url: Config.firebaseURL)
        ref.removeUser(email, password: password,
            withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                } else {
                    // Password changed successfully
                }
        })
    }
}