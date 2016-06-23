//
//  InfoMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class InfoMenu: CCNode {
    
    weak var infoScroller: CCScrollView!
    
    func didLoadFromCCB() {
        infoScroller.delegate = self
    }
}

extension InfoMenu: CCScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: CCScrollView!) {
        
    }
    
    func scrollViewWillBeginDragging(scrollView: CCScrollView!) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: CCScrollView!) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: CCScrollView!) {
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: CCScrollView!) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: CCScrollView!, willDecelerate decelerate: Bool) {
        
    }
}