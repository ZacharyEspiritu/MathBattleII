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
        let handle = FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
            if let user = user {
                print("User is signed in with uid:", user.uid)
            } else {
                print("No user is signed in.")
            }
        }
        
        FIRAuth.auth()!.removeAuthStateDidChangeListener(handle)
    }
    
    func checkImmediatelyIfUserIsAuthenticated() -> Bool {
        let ref = FIRAuth.auth()!
        if ref.currentUser != nil {
            // User is authenticated
            print(ref.currentUser)
            return true
        } else {
            // User is not authenticated
            return false
        }
    }
    
    func authenticateUser(email email: String, password: String) {
        authenticateUser(email: email, password: password, errorHandler: { _ in })
    }
    
    func authenticateUser(email email: String, password: String, errorHandler: (String) -> ()) {
        FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { user, error in
            if let user = user {
                // Authentication just completed successfully :)
                // The logged in user's unique identifier
                print(user.uid)
                
                let userRef = FIRDatabase.database().reference().child("/users/\(user.uid)")
                // Attach a closure to read the data at our posts reference
                self.currentAuthenticationHandle = userRef.observeEventType(.Value,
                    withBlock: { snapshot in
                        self.saveUserDataLocally(snapshot: snapshot)
                        print("data saved")
                    },
                    withCancelBlock: { error in
                        errorHandler("Error occured when logging in.")
                })
            }
            else {
                if let error = error {
                    if let errorCode = FIRAuthErrorCode(rawValue: error.code) { // TODO: Handle all ErrorCode cases
                        let errorDescription = FirebaseErrorReader.convertToHumanReadableAlertDescription(errorCode)
                        errorHandler(errorDescription)
                    }
                }
            }
        })
    }
    
    func pushLocalUserDataToServer(user user: User) {
        if checkImmediatelyIfUserIsAuthenticated() {
            let ref = FIRDatabase.database().reference()
            let userData = user.convertToDictionaryFormat()
            print("saving data...")
            
            let dispatchGroup = dispatch_group_create()
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                ref.child("users").child((FIRAuth.auth()?.currentUser!.uid)!).setValue(userData)
                print("user data saved")
            }
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                ref.child(LeaderboardView.Ranked.rawValue).child((UserManager.sharedInstance.getCurrentUser()?.getDisplayName())!)
                    .setValue(userData["rating"])
                GameCenterInteractor.sharedInstance.saveLeaderboardScore(forLeaderboardType: .Ranked, score: userData["rating"] as! Int)
                print("Ranked leaderboard data saved")
            }
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                ref.child(LeaderboardView.Practice.rawValue).child((UserManager.sharedInstance.getCurrentUser()?.getDisplayName())!)
                    .setValue(userData["practiceHighScore"])
                GameCenterInteractor.sharedInstance.saveLeaderboardScore(forLeaderboardType: .Practice, score: userData["practiceHighScore"] as! Int)
                print("practice leaderboard data saved")
            }
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                ref.child(LeaderboardView.Overall.rawValue).child((UserManager.sharedInstance.getCurrentUser()?.getDisplayName())!)
                    .setValue(userData["experienceLevel"])
                GameCenterInteractor.sharedInstance.saveLeaderboardScore(forLeaderboardType: .Overall, score: userData["experienceLevel"] as! Int)
                print("overall leaderboard data saved")
            }
            dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                print("data saved")
            }
        }
    }
    
    private func saveUserDataLocally(snapshot snapshot: FIRDataSnapshot!) {
        if let userData = snapshot.value as? NSDictionary {
            let displayName = userData.objectForKey("displayName") as! String
            let email = userData.objectForKey("email") as! String
            let numberOfGamesPlayed = userData.objectForKey("numberOfGamesPlayed") as! Int
            let numberOfWins = userData.objectForKey("numberOfWins") as! Int
            let numberOfLosses = userData.objectForKey("numberOfLosses") as! Int
            let numberOfSolves = userData.objectForKey("numberOfSolves") as! Int
            let provider = userData.objectForKey("provider") as! String
            let rating = userData.objectForKey("rating") as! Int
            let ratingFloor = userData.objectForKey("ratingFloor") as! Int
            let experienceLevel = userData.objectForKey("experienceLevel") as! Int
            let coins = userData.objectForKey("coins") as! Int
            let practiceHighScore = userData.objectForKey("practiceHighScore") as! Int
            
            let friends: [String]
            if userData.objectForKey("friends") != nil {
                friends = userData.objectForKey("friends") as! [String]
            }
            else {
                friends = []
            }
            
            let user = User(uid: snapshot.key, displayName: displayName, email: email, provider: provider, numberOfGamesPlayed: numberOfGamesPlayed, numberOfWins: numberOfWins, numberOfLosses: numberOfLosses, numberOfSolves: numberOfSolves, rating: rating, ratingFloor: ratingFloor, experienceLevel: experienceLevel, coins: coins, practiceHighScore: practiceHighScore, friends: friends)
            user.delegate = self
            
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
    }
    
    
    // MARK: Change User Data Functions
    
    func changeDisplayName(newDisplayName newDisplayName: String) {
        let user = UserManager.sharedInstance.getCurrentUser()
        user?.setDisplayName(newDisplayName: newDisplayName)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let ref = FIRDatabase.database().reference()
            ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("displayName").setValue(newDisplayName)
        })
    }
    
    func changeEmail(oldEmail oldEmail: String, newEmail: String, password: String) {
        FIRAuth.auth()?.currentUser?.updateEmail(newEmail, completion: { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Email changed successfully
            }
        })
    }
    
    func changePassword(email email: String, oldPassword: String, newPassword: String) {
        FIRAuth.auth()?.currentUser?.updatePassword(newPassword, completion: { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Password changed successfully
            }
        })
    }
    
    func sendResetPasswordEmail(forUserEmail email: String) {
        FIRAuth.auth()?.sendPasswordResetWithEmail(email, completion: { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Password reset sent successfully
            }
        })
    }
    
    
    // MARK: Remove User Functions
    
    func logoutCurrentSession() {
        FIRAuth.auth()?.removeAuthStateDidChangeListener(currentAuthenticationHandle)
        try! FIRAuth.auth()?.signOut()
    }
    
    func deleteUser(email email: String, password: String) {
//        let ref = FIRDatabase.database().reference()
//        ref.removeUser(email, password: password,
//            withCompletionBlock: { error in
//                if error != nil {
//                    // There was an error processing the request
//                } else {
//                    // Password changed successfully
//                }
//        })
    }
}

extension AuthenticationHandler: UserDelegate {
    func localUserDataDidUpdate(user: User) {
        pushLocalUserDataToServer(user: user)
    }
}