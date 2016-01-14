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
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocationInGridOptional: CGPoint?
        print("touch")
        if touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2 {
            touchLocationInGridOptional = touch.locationInNode(bottomGrid)
            guard let touchLocationInGrid = touchLocationInGridOptional else {
                return
            }
            print(touchLocationInGrid)
            
            let gridContentSize: CGSize = bottomGrid.contentSizeInPoints

            if touchLocationInGrid.x < gridContentSize.width / 3 { print("A")
                if touchLocationInGrid.y < gridContentSize.height / 3 { print("3")
                    
                }
                else if touchLocationInGrid.y < (gridContentSize.height / 3) * 2 { print("2")
                    
                }
                else { print("1")
                    
                }
            }
            else if touchLocationInGrid.x < (gridContentSize.width / 3) * 2 { print("B")
                if touchLocationInGrid.y < gridContentSize.height / 3 { print("3")
                    
                }
                else if touchLocationInGrid.y < (gridContentSize.height / 3) * 2 { print("2")
                    
                }
                else { print("1")
                    
                }
            }
            else { print("C")
                if touchLocationInGrid.y < gridContentSize.height / 3 { print("3")
                    
                }
                else if touchLocationInGrid.y < (gridContentSize.height / 3) * 2 { print("2")
                    
                }
                else { print("1")
                    
                }
            }
            manager.determineTappedTile(touchLocationInGrid)
        }
        else {
            touchLocationInGridOptional = touch.locationInNode(topGrid)
            guard let touchLocationInGrid = touchLocationInGridOptional else {
                return
            }
            manager.determineTappedTile(touchLocationInGrid)
        }
    }
    
    func generateNewPuzzle() {
        
    }
}