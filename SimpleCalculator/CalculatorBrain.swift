//
//  CalculatorBrain.swift
//  SimpleCalculator
//
//  Created by Santosh - Humber on 2023-05-25.
//

import Foundation

class CalculatorBrain {
    
    var userInput: [String] = []
    var trackHistory = false
    
    var inputHistory: String = ""
    
    func push(_ input: String) throws {        
        switch input {
        case "0"..."9":
            if let lastItem = userInput.last {
                //If last input is number, app can only handle single digit
                if ("0"..."9").contains(lastItem) {
                    throw CalculatorException.operandAfterOperand
                }
                userInput.append(input)
            } else {
                userInput.append(input)
            }
        case "+", "-", "/", "*":
            if let lastItem = userInput.last {
                if ["+", "-", "/", "*"].contains(lastItem) {
                    //user tries to input operator twice
                    throw CalculatorException.operatorAfterOperator
                }
                userInput.append(input)
            } else {
                //list is empty and user tries to input operator
                throw CalculatorException.firstValueIsOperator
            }
        default:
            //invalid character -> throw error
            throw CalculatorException.invalidCharacter
        }
    }
    
    func calc() throws -> Int  {
        guard !userInput.isEmpty else {
            throw CalculatorException.inputIsEmpty
        }
        
        if let lastItem = userInput.last,
           ["+", "-", "/", "*"].contains(lastItem) {
            throw CalculatorException.invalidSyntax
        }
        
        var result: Int = 0
        var calcOperator: String? = nil
        for item in userInput {
            switch item {
            case "0"..."9":
                if calcOperator == nil {
                    result = Int(String(item))!
                    continue
                }
                let operand = Int(String(item))!
                
                if calcOperator == "/" && operand == 0 {
                    clear()
                    throw CalculatorException.divisionByZero
                }
                
                switch calcOperator {
                case "+":
                    result += operand
                case "-":
                    result -= operand
                case "*":
                    result *= operand
                case "/":
                    result /= operand
                default:
                    print("TODO")
                }
            case "+", "-", "/", "*":
                calcOperator = item
            default:
                print("Should not happen.")
            }
        }
        
        if (trackHistory) {
            let userInputStrWithResult = " \(userInput.joined(separator: " ")) = \(result) \n"
            inputHistory.append(userInputStrWithResult)
        }
        clear()
        
        return result
    }
    
    func toggleHistory() {
        trackHistory = !trackHistory
        if (!trackHistory) {
            
            inputHistory.removeAll()
        }
    }
    
    func clear() {
        userInput.removeAll()
    }
}

enum CalculatorException: Error {
    case inputIsEmpty
    case operandAfterOperand
    case firstValueIsOperator
    case operatorAfterOperator
    case invalidCharacter
    case invalidSyntax
    case divisionByZero
}
