//
//  ShopManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopManager {
    
    static func getItemsWithStatus() -> [ShopItem] {
        var items: [ShopItem] = []
        items.append(ShopItem(id: 1, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 2, name: "Blue", price: 10000, imagePath: "test.png"))
        items.append(ShopItem(id: 3, name: "Blue", price: 5000, imagePath: "test.png"))
        items.append(ShopItem(id: 4, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 5, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 6, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 7, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 8, name: "Blue", price: 1000, imagePath: "test.png"))
        items.append(ShopItem(id: 9, name: "Blue", price: 1000, imagePath: "test.png"))
        return items
    }
    
    static func retrieveItemsFromFirebase() -> [ShopItem] {
        var shopItems: [ShopItem] = []
        FIRDatabase.database().reference().child("").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? [String : NSDictionary] {
                for key in data.keys {
                    let itemData = data[key]
                    let name = itemData?.objectForKey("name") as! String
                    let price = itemData?.objectForKey("price") as! Int
                    let image = itemData?.objectForKey("image") as! String
                    shopItems.append(ShopItem(id: 1, name: name, price: price, imagePath: image))
                }
            }
        })
        return shopItems // TODO: Fix this code, which returns empty shopItems array before FIRDatabase closure is called because of latency
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
            }
        })
    }
}