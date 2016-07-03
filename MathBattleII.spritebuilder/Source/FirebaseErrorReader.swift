//
//  FirebaseErrorReader.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/2/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class FirebaseErrorReader {
    
    static func convertToHumanReadableAlertDescription(errorCode: FIRAuthErrorCode) -> String {
        let errorDescription: String!
        switch errorCode {
        case .ErrorCodeInvalidCredential:
            errorDescription = "Invalid credentials. Make sure your email and password is correct."
        case .ErrorCodeUserDisabled:
            errorDescription = "Your account is currently disabled. Try again later."
        case .ErrorCodeEmailAlreadyInUse:
            errorDescription = "Email is already in use on a different account."
        case .ErrorCodeWrongPassword:
            errorDescription = "Incorrect password."
        case .ErrorCodeUserNotFound:
            errorDescription = "User with specified email and password not found."
        case .ErrorCodeInvalidEmail:
            errorDescription = "Invalid email."
        case .ErrorCodeTooManyRequests:
            errorDescription = "Too many attempts made. Try again later."
        case .ErrorCodeRequiresRecentLogin:
            errorDescription = "This action requires you to log in again."
        case .ErrorCodeNetworkError:
            errorDescription = "A network error occured. Check your internet connection."
        case .ErrorCodeInvalidUserToken:
            errorDescription = "Your session has expired. Please log in again."
        case .ErrorCodeUserTokenExpired:
            errorDescription = "Your session has expired. Please log in again."
        case .ErrorCodeWeakPassword:
            errorDescription = "Your password is too weak. Please choose another one."
        case .ErrorCodeKeychainError:
            errorDescription = "Could not access the keychain. Please log in manually."
        default:
            errorDescription = "Error occured when logging in."
        }
        return errorDescription
    }
}