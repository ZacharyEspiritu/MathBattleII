//
//  ShopManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopManager {
    
    static var items: [ShopItem] = []
    
    static func getItemsWithStatus() -> [ShopItem] {
        items.removeAll()
        items.append(ShopItem(id: 1, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 4, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 5, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 6, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 7, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 8, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 9, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 3, name: "Blue", price: 5000, imagePath: "test.png"))
        items.append(ShopItem(id: 2, name: "Blue", price: 10000, imagePath: "test.png"))
        return items
    }
    
    // MARK: Database Interactors
    
    static func markBoughtItemsFromFirebase() {
        guard let user = UserManager.sharedInstance.getCurrentUser() else {
            print("Could not retrieve items from Firebase because user was not logged in!")
            return
        }
        
        FIRDatabase.database().reference().child("users").child(user.getUID()).child("items").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let boughtItemIDs = snapshot.value as? [Int] {
                for itemID in boughtItemIDs {
                    items[itemID].markAsBought()
                }
            }
        })
    }
    
    static func attemptToBuyItem(item item: ShopItem, completionHandler: (Void -> Void), errorHandler: (Void -> Void)) {
        guard let user = UserManager.sharedInstance.getCurrentUser() where user.getCoins() >= item.getPrice() else {
            return
        }
        
        user.setCoins(newCoins: user.getCoins() - item.getPrice())
        user.addItem(itemID: item.getID())
        
        FIRDatabase.database().reference().child("users").child(user.getUID()).setValue(user.convertToDictionaryFormat(), withCompletionBlock: { (error, _) in
            if let _ = error {
                errorHandler()
            }
            else {
                completionHandler()
                FIRAnalytics.logEventWithName(kFIREventSpendVirtualCurrency, parameters: [
                    kFIRParameterItemName: item.getName(),
                    kFIRParameterVirtualCurrencyName: "coins",
                    kFIRParameterValue: item.getPrice()
                ])
            }
        })
    }
}