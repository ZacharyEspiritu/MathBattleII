//
//  ShopScrollViewCell.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopScrollViewCell: CCNode {
    
    weak var itemNameLabel, itemPriceLabel: CCLabelTTF!
    weak var cellTouchedButton, confirmButton: CCButton!
    weak var slideOutColorNode: CCNodeColor!
    
    private var item: ShopItem!
    
    var delegate: ShopScrollViewCellDelegate?
    
    var state: ShopScrollViewCellState = .Normal {
        didSet {
            switch state {
            case .Normal:
                disableConfirmedState()
            case .Confirmable:
                enableConfirmedState()
            default: break
            }
        }
    }
    
    // MARK: Button Functions
    
    func didLoadFromCCB() {
        confirmButton.enabled = false
    }
    
    func cellTouched() {
        if state == .Confirmable {
            state = .Normal
            disableConfirmedState()
        }
        else if state == .Normal {
            delegate?.shopScrollViewCellTouched(self)
        }
    }
    
    func confirmButtonPressed() {
        if state == .Confirmable {
            state = .Bought
            delegate?.shopScrollViewCellConfirmed(self)
            displayBoughtState()
        }
    }
    
    // MARK: Animation Functions
    
    private func enableConfirmedState() {
        self.animationManager.runAnimationsForSequenceNamed("DisplayConfirmButton")
        confirmButton.enabled = true
    }
    
    private func disableConfirmedState() {
        self.animationManager.runAnimationsForSequenceNamed("Default Timeline")
        confirmButton.enabled = false
    }
    
    private func displayBoughtState() {
        self.animationManager.runAnimationsForSequenceNamed("DisplayBought")
        confirmButton.enabled = false
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
    func shopScrollViewCellConfirmed(cell: ShopScrollViewCell)
}

enum ShopScrollViewCellState {
    case Normal, Confirmable, Bought
}