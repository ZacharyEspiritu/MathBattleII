//
//  ShopScrollViewCell.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopScrollViewCell: CCNode {
    
    private var item: ShopItem!
    
    weak var itemNameLabel, itemPriceLabel: CCLabelTTF!
    
    var delegate: ShopScrollViewCellDelegate?
    
    // MARK: Button Functions
    
    func cellTouched() {
        delegate?.shopScrollViewCellTouched(self)
    }
    
    // MARK: Data Functions
    
    func setData(item item: ShopItem) {
        self.item = item
        itemNameLabel.string = item.getName()
        itemPriceLabel.string = "\(item.getPrice())"
    }
    
    func getItem() -> ShopItem {
        return item
    }
}

protocol ShopScrollViewCellDelegate {

    func shopScrollViewCellTouched(cell: ShopScrollViewCell)
}
