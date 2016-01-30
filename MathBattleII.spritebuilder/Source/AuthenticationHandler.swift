//
//  AuthenticationHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class AuthenticationHandler {
    
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
        
        // ref.removeAuthEventObserverWithHandle(handle)
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
                }
                else {
                    // Authentication just completed successfully :)
                    // The logged in user's unique identifier
                    print(authData.uid)
                    // Create a new user dictionary accessing the user's info
                    // provided by the authData parameter
                    let newUser = [
                        "provider": authData.provider,
                        "displayName": authData.providerData["displayName"] as? NSString as? String
                    ]
                    // Create a child path with a key set to the uid underneath the "users" node
                    // This creates a URL path like the following:
                    //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                    ref.childByAppendingPath("users")
                        .childByAppendingPath(authData.uid).setValue(newUser)
                }
        })
    }
    
    func logoutCurrentSession() {
        let ref = Firebase(url: Config.firebaseURL)
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