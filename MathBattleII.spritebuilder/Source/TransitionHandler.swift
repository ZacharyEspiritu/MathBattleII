//
//  TransitionHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/9/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TransitionHandler {
    
    static var currentTransitionScene: CCScene!
    static var completionHandler: ((Void) -> Void)!
    
    static func startTransition(outgoingSceneAnimated outgoingSceneAnimated: Bool, incomingSceneAnimated: Bool, withCompletionHandler completion: (Void -> Void)) {
        let transitionScene = CCScene()
        transitionScene.addChild(CCBReader.load("TransitionScene") as! TransitionScene)
        let transition = CCTransition(crossFadeWithDuration: 0.35)
        transition.incomingSceneAnimated = incomingSceneAnimated
        transition.outgoingSceneAnimated = outgoingSceneAnimated
        CCDirector.sharedDirector().presentScene(transitionScene, withTransition: transition)
        currentTransitionScene = transitionScene
        completionHandler = completion
    }
    
    static func endTransition() {
        completionHandler()
    }
}