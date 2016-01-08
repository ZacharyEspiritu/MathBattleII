//
//  Grid.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Grid: CCNode {
    
    private weak var tileA1, tileB1, tileC1,
                     tileA2, tileB2, tileC2,
                     tileA3, tileB3, tileC3: Tile!
    private var tileArray: [Tile] = []
    
    private var side: Side!
        
    func didLoadFromCCB() {
        tileArray = [tileA1, tileB1, tileC1,
                     tileA2, tileB2, tileC2,
                     tileA3, tileB3, tileC3]
    }
    
    func getSide() -> Side {
        return side
    }
    
    func setSide(side: Side) {
        self.side = side
    }
}

enum Side {
    case Top, Bottom
}