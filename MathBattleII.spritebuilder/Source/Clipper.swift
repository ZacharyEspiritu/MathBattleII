//
//  Clipper.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/25/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Clipper: CCNode {
    
    override func visit(renderer: CCRenderer!, parentTransform: UnsafePointer<GLKMatrix4>) {
        
        let s: CGFloat = CCDirector.sharedDirector().contentScaleFactor
        let worldPosition: CGPoint = self.convertToWorldSpace(CGPointZero)
        
        renderer.enqueueBlock({
            glEnable(GLenum(GL_SCISSOR_TEST));
            glScissor(GLint(worldPosition.x*s), GLint(worldPosition.y*s), GLint(self.contentSizeInPoints.width*s), GLint(self.contentSizeInPoints.height*s));
        }, globalSortOrder: 0, debugLabel: nil, threadSafe: false)
        
        super.visit(renderer, parentTransform: parentTransform)
        
        renderer.enqueueBlock({
            glDisable(GLenum(GL_SCISSOR_TEST));
        }, globalSortOrder: 0, debugLabel: nil, threadSafe: false)
    }
}