//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jeffrey Haselby on 2/12/15.
//  Copyright (c) 2015 Jeffrey Haselby. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    fileprivate enum Op: CustomStringConvertible
    {
        case operand(Double)
        case symbolicOperand(String)
        case nullaryOperation(String, Double)
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .symbolicOperand(let symbol):
                    return symbol
                case .nullaryOperation(let symbol,_):
                    return symbol
                case .unaryOperation(let symbol, _):
                    return symbol
                case .binaryOperation(let symbol, _):
                    return symbol
                    
                }
            }
        }
    }
    
    fileprivate var opStack = [Op]()

    fileprivate var knownOps = [String: Op]()
    
    var variableValues: Dictionary<String,Double> = [ : ]
    
    init() {
        knownOps["×"] = Op.binaryOperation("×", *)
        knownOps["÷"] = Op.binaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.binaryOperation("+", +)
        knownOps["−"] = Op.binaryOperation("−") {$1 - $0}
        knownOps["SIN"] = Op.unaryOperation("SIN",sin)
        knownOps["COS"] = Op.unaryOperation("COS",cos)
        knownOps["TAN"] = Op.unaryOperation("TAN",tan)
        knownOps["√"] = Op.unaryOperation("√",sqrt)
        knownOps["+/-"] = Op.unaryOperation("+/-",{$0 * (-1)})
        knownOps["π"] = Op.nullaryOperation("π",Double.pi)
    }
    
    fileprivate func evaluate(_ ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .operand(let operand):
                return (operand, remainingOps)
            case .symbolicOperand(let symbol):
                return(variableValues[symbol], remainingOps)
            case .nullaryOperation(_, let numericalvalue):
                return(numericalvalue, remainingOps)
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                return ( operation(operand), operandEvaluation.remainingOps)
                }
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                    return ( operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(String(describing: result)) with \(remainder) left over")
        return result
    }
    
    func pushOperand(_ operand: Double) -> Double? {
    opStack.append(Op.operand(operand))
        return evaluate()
    }
    
    func pushOperand(_ symbol: String) -> Double? {
        opStack.append(Op.symbolicOperand(symbol))
        return evaluate()
    }
    
    
    func performOperation(_ symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
        opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack()
    {
    opStack = []
    
    }

}
