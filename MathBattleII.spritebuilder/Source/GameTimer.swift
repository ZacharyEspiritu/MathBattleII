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
    
    /**
     Creates a new `GameTimer` object with `gameLengthInSeconds` time.
     - parameter gameLengthInSeconds:  the amount of time to start the `GameTimer` with
     */
    init(gameLengthInSeconds: Int) {
        remainingTime = gameLengthInSeconds
        super.init()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    /**
     If the `GameTimer` is not paused, decreases the `remainingTime` by 1.
     Also, pauses the `GameTimer` if the `remainingTime` is less than or equal to 0.
     */
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
    
    /**
     Starts/unpauses the `GameTimer`.
     */
    func startTimer() {
        isPaused = false
        delegate?.gameTimerDidStart(self)
    }
    
    /**
     Pauses the `GameTimer`.
     */
    func pauseTimer() {
        isPaused = true
        delegate?.gameTimerDidPause(self)
    }
    
    /**
     Returns the `remainingTime` on the `GameTimer`.
     - returns:  the amount of `remainingTime`
     */
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