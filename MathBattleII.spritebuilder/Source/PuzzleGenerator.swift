//
//  PuzzleGenerator.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PuzzleGenerator {
    
    static let sharedInstance = PuzzleGenerator()
    
    private let amountOfPossibleNumbers: Int = 10
    private let amountOfPossibleOperators: Int = 3
    
    /**
     Generates a new puzzle and returns a tuple with all of the necessary information to handle the puzzle.
     * The `Int` corresponds to the `targetNumber` for the puzzle.
     * The `String` corresponds to the generated `sampleEquationSolution` for the puzzle.
     * The `[TileValue]` corresponds to the set of 9 tiles to display to the player in the `Grid`
     - returns:   a tuple of `(Int, String, [TileValue])`. See above
     */
    func generateNewPuzzle() -> (Int, String, [TileValue]) {
        var targetNumber: Int = 0
        var sampleEquationSolution: String = ""
        var tileSet: [TileValue] = []
        
        let firstNumber: TileValue = chooseRandomNumber()
        targetNumber = firstNumber.rawValue
        sampleEquationSolution = "\(firstNumber.stringValue)"
        tileSet.append(firstNumber)
        
        for _ in 0..<4 {
            let nextNumber: TileValue = chooseRandomNumber()
            let nextOperator: TileValue = chooseRandomOperator()
            
            switch nextOperator {
            case TileValue.add:
                targetNumber += nextNumber.rawValue
            case TileValue.subtract:
                targetNumber -= nextNumber.rawValue
            case TileValue.multiply:
                targetNumber *= nextNumber.rawValue
            default:
                assertionFailure()
            }
            
            sampleEquationSolution = sampleEquationSolution + " \(nextOperator.stringValue) \(nextNumber.stringValue)"
            tileSet.append(nextNumber)
            tileSet.append(nextOperator)
        }
        
        sampleEquationSolution = sampleEquationSolution + " = \(targetNumber)"
        print(sampleEquationSolution)
        
        return (targetNumber, sampleEquationSolution, tileSet)
    }
    
    /**
     Randomly selects a `TileValue` of `TileType.Number`.
     - returns:   a `TileValue` of `TileType.Number`.
     */
    private func chooseRandomNumber() -> TileValue {
        return TileValue(rawValue: Int(arc4random_uniform(UInt32(amountOfPossibleNumbers))))!
    }
    
    /**
     Randomly selects a `TileValue` of `TileType.Operator`.
     - returns:   a `TileValue` of `TileType.Operator`.
     */
    private func chooseRandomOperator() -> TileValue {
        var tileValue: TileValue?
        switch Int(arc4random_uniform(UInt32(amountOfPossibleOperators))) {
        case 0:
            tileValue = TileValue.add
        case 1:
            tileValue = TileValue.subtract
        case 2:
            tileValue = TileValue.multiply
        default:
            assertionFailure()
        }
        return tileValue!
    }
}