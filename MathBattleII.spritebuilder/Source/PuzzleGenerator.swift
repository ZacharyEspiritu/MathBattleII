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
    
    private func chooseRandomNumber() -> TileValue {
        var tileValue: TileValue?
        switch Int(arc4random_uniform(UInt32(amountOfPossibleNumbers))) {
        case 0:
            tileValue = TileValue.zero
        case 1:
            tileValue = TileValue.one
        case 2:
            tileValue = TileValue.two
        case 3:
            tileValue = TileValue.three
        case 4:
            tileValue = TileValue.four
        case 5:
            tileValue = TileValue.five
        case 6:
            tileValue = TileValue.six
        case 7:
            tileValue = TileValue.seven
        case 8:
            tileValue = TileValue.eight
        case 9:
            tileValue = TileValue.nine
        default:
            assertionFailure()
        }
        return tileValue!
    }
    
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