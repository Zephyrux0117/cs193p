//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by xiongmingjing on 28/11/2016.
//  Copyright © 2016 xiongmingjing. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    var description = ""
    
    var result: Double {
        get {
            return accumulator
        }
    }
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+/-": Operation.UnaryOperation() { -1 * $0},
        "+": Operation.BinaryOperation(+),
        "−": Operation.BinaryOperation(-),
        "×": Operation.BinaryOperation(*),
        "÷": Operation.BinaryOperation(/),
        "=": Operation.Equals
    ]
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    func performOperation(symbol: String) {
        
        if let opration = operations[symbol] {
            switch opration {
            case .Constant(let value):
                accumulator = value
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
