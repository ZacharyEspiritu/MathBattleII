//
//  GameplayScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class GameplayScene: CCNode {
    
    weak var topGrid, bottomGrid: Grid!
    var manager = GridManager()
    
    func didLoadFromCCB() {
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocationOptional: CGPoint?
        print("touch")
        if touch.locationInWorld().y > CCDirector.sharedDirector().viewSize().width / 2 {
            touchLocationOptional = touch.locationInNode(topGrid)
            guard let touchLocation = touchLocationOptional else {
                return
            }
            manager.determineTappedTile(touchLocation)
        }
        else {
            touchLocationOptional = touch.locationInNode(bottomGrid)
            guard let touchLocation = touchLocationOptional else {
                return
            }
            manager.determineTappedTile(touchLocation)
        }
    }
    
    func generateNewPuzzle() {
        
    }
}