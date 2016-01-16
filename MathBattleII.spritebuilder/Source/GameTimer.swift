//
//  GameTimer.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class GameTimer: NSObject {
    
    private var remainingTime: Int
    private var isPaused: Bool = true
    
    var delegate: GameTimerDelegate?
    
    init(gameLengthInSeconds: Int) {
        remainingTime = gameLengthInSeconds
        super.init()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        if !isPaused {
            remainingTime--
            delegate?.gameTimerDidUpdate(self)
            
            if remainingTime <= 0 {
                delegate?.gameTimerDidFinish(self)
                isPaused = true
            }
        }
    }
    
    func startTimer() {
        isPaused = false
        print("test")
        delegate?.gameTimerDidStart(self)
    }
    
    func pauseTimer() {
        isPaused = true
        delegate?.gameTimerDidPause(self)
    }
    
    func getRemainingTime() -> Int {
        return remainingTime
    }
}

protocol GameTimerDelegate {
    
    /**
     Called whenever `remainingTime` updates.
     - parameter gameTimer:  the `GameTimer` object
     */
    func gameTimerDidUpdate(gameTimer: GameTimer)
    
    /**
     Called when `remainingTime` hits zero.
     - parameter gameTimer:  the `GameTimer` object
     */
    func gameTimerDidFinish(gameTimer: GameTimer)
    
    /**
     Called when the `GameTimer` begins ticking down.
     - parameter gameTimer:  the `GameTimer` object
     */
    func gameTimerDidStart(gameTimer: GameTimer)
    
    /**
     Called when the `GameTimer` is paused.
     - parameter gameTimer:  the `GameTimer` object
     */
    func gameTimerDidPause(gameTimer: GameTimer)
}