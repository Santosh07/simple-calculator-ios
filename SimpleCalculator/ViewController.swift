//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Santosh - Humber on 2023-05-25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var historyOutput: UITextView!
    @IBOutlet weak var outputDisplay: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var toggleHistoryButton: UIButton!
    
    var calculatorBrain = CalculatorBrain()
    var clearInput = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyOutput.isHidden = true
    }
    
    @IBAction func inputHandler(_ sender: UIButton) {
        errorLabel.text = ""
        
        if clearInput {
            outputDisplay.text = ""
            clearInput = false
        }
        
        if let buttonType = sender.titleLabel?.text {
            do {
                try handleUserInput(buttonType)
            } catch CalculatorException.inputIsEmpty {
                errorLabel.text = "Input is Empty."
            } catch CalculatorException.operatorAfterOperator {
                errorLabel.text = "Cannot input two operator in a row."
            } catch CalculatorException.operandAfterOperand {
                errorLabel.text = "Cannot input double digit number."
            } catch CalculatorException.firstValueIsOperator {
                errorLabel.text = "First value cannot be operator."
            } catch CalculatorException.invalidCharacter {
                errorLabel.text = "Invalid Charapter."
            } catch CalculatorException.invalidSyntax {
                errorLabel.text = "Invalid Syntax"
            } catch CalculatorException.divisionByZero {
                errorLabel.text = "Cannot divide by zero"
                clearInput = true
            } catch {
                errorLabel.text = "Error occurred."
            }
        }
    }
    
    func handleUserInput(_ input: String) throws {
        switch input {
        case "0"..."9", "+", "-", "*", "/":
            try calculatorBrain.push(input)
            outputDisplay.text = "\(outputDisplay.text!) \(input)"
        case "=":
            //Calcuate
            print(calculatorBrain.userInput)
            let result = try calculatorBrain.calc()
            outputDisplay.text = "\(outputDisplay.text!) = \(result)"
            if calculatorBrain.trackHistory {
                historyOutput.text = calculatorBrain.inputHistory
            }
            
            clearInput = true
        case "C":
            outputDisplay.text = ""
            calculatorBrain.clear()
        default:
            throw CalculatorException.invalidCharacter
        }
    }
    
    @IBAction func toggleHistory(_ sender: UIButton) {
        calculatorBrain.toggleHistory()
        historyOutput.isHidden = !calculatorBrain.trackHistory
        historyOutput.text = calculatorBrain.inputHistory
        if calculatorBrain.trackHistory {
            toggleHistoryButton.setTitle("Standard - No History", for: .normal)
        } else {
            toggleHistoryButton.setTitle("Advanced - With History", for: .normal)
        }
    }
}

