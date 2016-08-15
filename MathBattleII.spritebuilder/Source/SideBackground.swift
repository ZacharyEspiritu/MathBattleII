//
//  SideBackground.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 8/14/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class SideBackground: CCNode {
    
    weak var colorNode: CCNodeColor!
    
    weak var background1, background2: CCSprite!
    var backgrounds: [CCSprite] = []
    
    var animationSpeed: CGFloat = 35
    
    func didLoadFromCCB() {
        backgrounds = [background1, background2]
    }
    
    func setBackgroundColor(color: CCColor) {
        colorNode.color = color
    }
    
    override func update(delta: CCTime) {
        let scale = CCDirector.sharedDirector().contentScaleFactor
        for background in backgrounds {
            background.position.y += animationSpeed * CGFloat(delta)
            background.position.y = round(background.position.y * scale) / scale
            if background.position.y > self.contentSize.height {
                background.position.y = background.position.y - (background.contentSize.height * 2)
            }
        }
    }
}

class SideBackgroundClipped: CCNode {
    
    weak var colorNode: CCNodeColor!
    
    weak var background1, background2: CCSprite!
    var backgrounds: [CCSprite] = []
    
    var animationSpeed: CGFloat = 35
    
    func didLoadFromCCB() {
        backgrounds = [background1, background2]
    }
    
    func setBackgroundColor(color: CCColor) {
        colorNode.color = color
    }
    
    override func update(delta: CCTime) {
        let scale = CCDirector.sharedDirector().contentScaleFactor
        for background in backgrounds {
            background.position.y += animationSpeed * CGFloat(delta)
            background.position.y = round(background.position.y * scale) / scale
            if background.position.y > self.contentSize.height {
                background.position.y = background.position.y - (background.contentSize.height * 2)
            }
        }
    }
}