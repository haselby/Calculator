//
//  ViewController.swift
//  Calculator
//
//  Created by Jeffrey Haselby on 1/24/15.
//  Copyright (c) 2015 Jeffrey Haselby. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! //unwraps optional returning string. Would crash if nil.
            if digit != "." || display.text!.range(of: ".") == nil || userIsInTheMiddleOfTypingANumber == false
            {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else{
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber && sender.currentTitle == "+/-" {
            display.text = "-" + display.text!
            return
        }
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
            displayValue = result
            } else {
                displayValue = nil
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        } else {
            displayValue = nil
        }

    }
        
    @IBAction func clearPressed() {
        brain.clearStack()
        brain.variableValues = [:]
        displayValue = nil
    }
    var displayValue: Double? {
        get{
            if let validNumber:Double = NumberFormatter().number(from: display.text!)?.doubleValue{
                return validNumber
            } else {
                return nil
            }
        }
        set{
            if let validNumber:Double = newValue{
                display.text = "\(validNumber)"
            }else {
                display.text = nil
            }
            userIsInTheMiddleOfTypingANumber = false;
        }
    
    }
    
    @IBAction func memoryPressed(_ sender: UIButton) {
        if sender.currentTitle == "M" {
            if userIsInTheMiddleOfTypingANumber {enter()}
            brain.pushOperand("M")
        }
        else if sender.currentTitle == "→M"{
        brain.variableValues["M"] = displayValue
        }
        displayValue = brain.evaluate()
    }
    
}

