//
//  ShopPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/30/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ShopPopup: CCNode {
    
    weak var scrollView: CCScrollView!
    weak var shopModal: CCNode!
    weak var focusOut: CCSprite!
    weak var focusOutButton: CCButton!
    
    let items = ShopManager.getItemsWithStatus()
    
    var delegate: ShopPopupDelegate?
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
        runOpeningAnimations()
        loadItemsIntoScrollView()
    }
    
    func backgroundTouched() {
        delegate?.focusOutAreaTouched(self)
    }
    
    private func runOpeningAnimations() {
        focusOut.opacity = 0
        focusOut.runAction(CCActionEaseSineOut(action: CCActionFadeTo(duration: 0.5, opacity: 1)))
        shopModal.position = CGPoint(x: 0.5, y: -0.5)
        shopModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.5, position: CGPoint(x: 0.5, y: 0.5))))
    }
    
    private func loadItemsIntoScrollView() {
        let scrollViewContent = CCNode()
        scrollViewContent.contentSize.width = 273
        
        let divider = generateDivider()
        divider.positionType.corner = CCPositionReferenceCorner.TopLeft
        scrollViewContent.addChild(divider)
        for index in 0..<items.count {
            let cell = CCBReader.load("ShopScrollViewCell") as! ShopScrollViewCell
            cell.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.TopLeft)
            cell.position = CGPoint(x: 0.5, y: CGFloat(index) * cell.contentSize.height)
            cell.setData(item: items[index])
            cell.addChild(generateDivider())
            cell.delegate = self // TODO: Cell Buttons Interfere when scrolled out of clipper node as you are not able to tap the focus out area
            scrollViewContent.contentSize.height += cell.contentSize.height
            scrollViewContent.addChild(cell)
        }
        scrollView.contentNode = scrollViewContent
    }
    
    private func generateDivider() -> CCNodeColor {
        let divider = CCNodeColor(color: CCColor.lightGrayColor())
        divider.contentSizeType = CCSizeType(widthUnit: .Normalized, heightUnit: .Points)
        divider.contentSize = CGSize(width: 1, height: 1)
        divider.anchorPoint = CGPoint(x: 0.5, y: 0)
        divider.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.BottomLeft)
        divider.position = CGPoint(x: 0.5, y: 0)
        return divider
    }
}

extension ShopPopup: ShopScrollViewCellDelegate {
    
    func shopScrollViewCellTouched(cell: ShopScrollViewCell) {
        let item = cell.getItem()
        if let user = UserManager.sharedInstance.getCurrentUser() {
            if item.getPrice() <= user.getCoins() {
                print("user has enough coins!")
            }
            else {
                print("user does not have enough coins!")
            }
        }
    }
}

protocol ShopPopupDelegate {
    
    func focusOutAreaTouched(shopPopup: ShopPopup)
}
