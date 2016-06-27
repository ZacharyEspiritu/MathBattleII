//
//  NewsScrollViewCell.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class NewsScrollViewCell: CCNode {
    
    weak var leftPipe, rightPipe: CCSprite!
    weak var background: CCSprite9Slice!
    weak var headerLabel, detailLabel: CCLabelTTF!
    
    func setData(pipeIndex index: Int, header: String, detail: String) {
        let pipe = index % 2 == 0 ? leftPipe : rightPipe
        pipe.removeFromParent()
        
        headerLabel.string = "+  " + header
        detailLabel.string = detail
    }
}