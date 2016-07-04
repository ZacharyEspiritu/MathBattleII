//
//  ShopItem.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopItem {
    
    private let id: Int
    private let name: String
    private let price: Int
    private var image: CCSprite?
    
    
    init(id: Int, name: String, price: Int, imagePath: String) {
        self.id = id
        self.name = name
        self.price = price
//        self.image = CCSprite(imageNamed: imagePath)
    }
    
    func getID() -> Int {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getPrice() -> Int {
        return price
    }
}