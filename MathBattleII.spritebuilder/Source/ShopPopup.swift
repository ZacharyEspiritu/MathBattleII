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
    weak var alertOverlay: CCNodeColor!
    
    let items = ShopManager.getItemsWithStatus()
    
    var delegate: ShopPopupDelegate?
    
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
        alertOverlay.cascadeOpacityEnabled = true
        alertOverlay.opacity = 0
        runOpeningAnimations()
        loadItemsIntoScrollView()
    }
    
    // MARK: Button Functions
    
    func closeButtonPressed() {
        delegate?.focusOutAreaTouched(self)
    }
    
    func backgroundTouched() {
        delegate?.focusOutAreaTouched(self)
    }
    
    // MARK: Animation Functions
    
    private func runOpeningAnimations() {
        focusOut.opacity = 0
        focusOut.runAction(CCActionEaseSineOut(action: CCActionFadeTo(duration: 0.5, opacity: 1)))
        shopModal.position = CGPoint(x: 0.5, y: -0.5)
        shopModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.5, position: CGPoint(x: 0.5, y: 0.5))))
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
    
    private func displayAlertOverlay() {
        alertOverlay.stopAllActions()
        alertOverlay.runAction(CCActionSequence(array: [CCActionFadeTo(duration: 0.15, opacity: 0.7), CCActionDelay(duration: 2), CCActionFadeTo(duration: 0.2, opacity: 0)]))
    }
    
    // MARK: Data Functions
    
    private func loadItemsIntoScrollView() {
        let scrollViewContent = CCNode()
        scrollViewContent.contentSize.width = 275
        let divider = generateDivider()
        divider.positionType.corner = CCPositionReferenceCorner.TopLeft
        scrollViewContent.addChild(divider)
        
        for index in 0..<items.count {
            let cell = CCBReader.load("ShopScrollViewCell") as! ShopScrollViewCell
            cell.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.TopLeft)
            cell.position = CGPoint(x: 0.5, y: CGFloat(index) * cell.contentSize.height)
            cell.setData(item: items[index])
            cell.addChild(generateDivider())
            cell.delegate = self
            
            scrollViewContent.contentSize.height += cell.contentSize.height
            scrollViewContent.addChild(cell)
        }
        
        scrollView.contentNode = scrollViewContent
        scrollView.delegate = self
        determineButtonStatus(inScrollView: scrollView)
    }
    
    private func determineButtonStatus(inScrollView scrollView: CCScrollView!) {
        for cell in scrollView.contentNode.children {
            if let scrollViewCell = cell as? ShopScrollViewCell {
                var convertedCellBoundingBox = scrollViewCell.boundingBox()
                convertedCellBoundingBox.origin = scrollViewCell.convertToWorldSpace(CGPointZero)
                var convertedScrollViewBoundingBox = scrollView.boundingBox()
                convertedScrollViewBoundingBox.origin = scrollView.convertToWorldSpace(CGPointZero)
                
                if CGRectIntersectsRect(convertedCellBoundingBox, convertedScrollViewBoundingBox) {
                    scrollViewCell.cellTouchedButton.enabled = true
                }
                else {
                    scrollViewCell.cellTouchedButton.enabled = false
                }
                
                if scrollViewCell.state == .Confirmable {
                    scrollViewCell.state = .Normal
                }
            }
        }
    }
}

extension ShopPopup: CCScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: CCScrollView!) {
        determineButtonStatus(inScrollView: scrollView)
    }
}

extension ShopPopup: ShopScrollViewCellDelegate {
    
    func shopScrollViewCellTouched(cell: ShopScrollViewCell) {
        guard let user = UserManager.sharedInstance.getCurrentUser() else {
            displayAlertOverlay()
            return
        }
        
        let item = cell.getItem()
        if item.getPrice() <= user.getCoins() {
            print("user has enough coins!")
            cell.state = .Confirmable
        }
        else {
            print("user does not have enough coins!")
            cell.displayNotEnoughCoinsAnimation()
        }
    }
    
    func shopScrollViewCellConfirmed(cell: ShopScrollViewCell) {
        let itemPrice = cell.getItem().getPrice()
        guard let user = UserManager.sharedInstance.getCurrentUser() where user.getCoins() > itemPrice else {
            cell.displayNotEnoughCoinsAnimation()
            return
        }
        ShopManager.attemptToBuyItem(item: cell.getItem(),
            completionHandler: { _ in
                cell.state = .Bought
                cell.displayBoughtState()
            }, errorHandler: { _ in
                cell.displayErrorAnimation()
        })
    }
}

protocol ShopPopupDelegate {
    
    func focusOutAreaTouched(shopPopup: ShopPopup)
}