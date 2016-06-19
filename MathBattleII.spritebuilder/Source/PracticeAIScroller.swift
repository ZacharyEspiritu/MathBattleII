//
//  PracticeAIScroller.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/23/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PracticeAIScroller: CCNode {
    
    let centerPosition = CGPoint(x: 0.5, y: 0.5)
    let leftStandbyPosition = CGPoint(x: 0, y: 0.4)
    let rightStandbyPosition = CGPoint(x: 1, y: 0.4)
    let leftSpawnPosition = CGPoint(x: -0.5, y: 0)
    let rightSpawnPosition = CGPoint(x: 1.5, y: 0)
    
    weak var icon1, icon2, icon3: CCSprite!
    var icons: [CCSprite] = []
    
    func didLoadFromCCB() {
        //removeAllChildren()
        icons = [icon1, icon2, icon3]
        userInteractionEnabled = true
    }
    
    func getCurrentlyFocusedAI() -> CCSprite {
        return icons[1]
    }
    
    private func rotateAIs(inDirection direction: Direction) {
        if direction == .Left {
            icons.append(icons.removeAtIndex(0))
        }
        else {
            icons.insert(icons.removeAtIndex(2), atIndex: 0)
        }
        for icon in icons {
            icon.stopAllActions()
        }
        
        icons[0].runAction(CCActionMoveTo(duration: 0.24, position: leftStandbyPosition))
        icons[0].runAction(CCActionScaleTo(duration: 0.24, scale: 0.86))
        icons[0].runAction(CCActionFadeTo(duration: 0.24, opacity: 0.5))
        
        icons[1].runAction(CCActionMoveTo(duration: 0.24, position: centerPosition))
        icons[1].runAction(CCActionScaleTo(duration: 0.24, scale: 1.0))
        icons[1].runAction(CCActionFadeTo(duration: 0.24, opacity: 1.0))
        
        icons[2].runAction(CCActionMoveTo(duration: 0.24, position: rightStandbyPosition))
        icons[2].runAction(CCActionScaleTo(duration: 0.24, scale: 0.86))
        icons[2].runAction(CCActionFadeTo(duration: 0.24, opacity: 0.5))
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let position = touch.locationInNode(self)
        if position.x < self.contentSize.width / 3 {
            rotateAIs(inDirection: .Left)
        }
        else if position.x > (self.contentSize.width / 3) * 2 {
            rotateAIs(inDirection: .Right)
        }
    }
}

enum Direction {
    case Up, Down, Left, Right
}