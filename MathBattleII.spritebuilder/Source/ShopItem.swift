//
//  ShopItem.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopItem {
    
    private let name: String
    private let price: Int
    private var image: CCSprite?
    
    
    init(name: String, price: Int, imagePath: String) {
        self.name = name
        self.price = price
//        self.image = CCSprite(imageNamed: imagePath)
    }
    
    func getName() -> String {
        return name
    }
    
    func getPrice() -> Int {
        return price
    }
    
//    func getImage() -> CCSprite {
//        return image
//    }
}