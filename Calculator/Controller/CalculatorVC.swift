//
//  ViewController.swift
//  Calculator
//
//  Created by Holland Clarke on 2/28/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import UIKit
import AVFoundation

class CalculatorVC: UIViewController {
    
    
    let calculator = Calculator()
    
    var btnSound: AVAudioPlayer!
    var decimalEntered = false

    @IBOutlet var numberLbl: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var expressionLbl: UILabel!
    
    var tree = ExpressionTree()
    var result: String = ""
    var runningValue = "0"
    var expression = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtnSound()
        
        // Ensure the the user text stays on the screen
        numberLbl.adjustsFontSizeToFitWidth = true
        expressionLbl.adjustsFontSizeToFitWidth = true
    }


    @IBAction func exponentBtnPressed(_ sender: UIButton) {
        playBtnSound()
        updateExpressionLbl(op: "^")
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        resetValues() // reset all the variabbles

    }
        
    @IBAction func equalBtnPressed(_ sender: UIButton) {
        
        let text = expressionLbl.text
        
        // We know that the label will always have some text in it so we can
        // force unwrap the string
        let postFixStr = convertToPostFix(infixStr: text!)
        
        // Ensure the postfix string is valid
        // If it is valid construct a tree then evaluate the tree
        // Otherwise, tell the user that it is a syntax error
        if isValidPostFix(postFixStr) {
            tree = constructTree(str: postFixStr)
            let value = evaluateTree(tree)
            
            numberLbl.text = String.localizedStringWithFormat("%.4f", value)
        } else {
            numberLbl.text = "Syntax Error"
        }
    }
 
    @IBAction func moduloBtnPressed(_ sender: UIButton) {
        updateExpressionLbl(op: "%")
    }
    
    @IBAction func divideBtnPressed(_ sender: UIButton) {
        updateExpressionLbl(op: "/")
    }
    
    @IBAction func multiplyBtnPressed(_ sender: UIButton) {
        updateExpressionLbl(op: "*")
    }
    
    @IBAction func subtractBtnPressed(_ sender: UIButton) {
        updateExpressionLbl(op: "-")
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        updateExpressionLbl(op: "+")
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        decimalEntered = false // reset decimalEntered because we are entering a new number
        playBtnSound()

    }
    @IBAction func decimalBtnPressed(_ sender: UIButton) {
        playBtnSound()
        // Make sure user does not enter more than one decimal in a number
        if !decimalEntered {
            expression.append(".")
            expressionLbl.text = expression
            decimalEntered = true
        }
    }
    
    @IBAction func numberBtnsPressed(_ sender: UIButton) {
        playBtnSound()
        // Update the expression label for every number pressed
        runningValue = String(sender.tag)
        expression.append(runningValue)
        expressionLbl.text = expression
    }

    // Functions converts the infix string into a postfix string in order
    // to build the expression tree
    private func convertToPostFix(infixStr: String) -> String {
        var array = [Token]()
        var token: Token!
        
        // Separates the string
        for str in infixStr.split(separator: " ") {
            let data = String(str) // convert the value to a string
            
            // Checks the value to see if it is a double
            if let value = Double(data) {
                token = Token(value: value)
            }
            // Different possible operations that will be in a string
            if data == "+" { token = Token(operation: .addition)}
            if data == "-" { token = Token(operation: .subtraction)}
            if data == "*" { token = Token(operation: .multiplication)}
            if data == "/" { token = Token(operation: .division)}
            if data == "%" { token = Token(operation: .modulo)}
            if data == "^" { token = Token(operation: .exponent)}
            array.append(token)
        }
        
        // return the postfix string
        return postFixBuilder(array)
    }
    
    private func updateExpressionLbl(op: String) {
        expression.append(" \(op) ")
        expressionLbl.text = expression
        runningValue = "0"
        
        
    }
    
    // Sets up the button sound used when user presses buttons
    private func setupBtnSound() {
        let path = Bundle.main.path(forResource: "btnSound", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // Play clicking sound when button is pressed
    private func playBtnSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        } else {
            btnSound.play()
        }
    }
    
    // Clear and reset variables and labels
    private func resetValues() {
        numberLbl.text = "0"
        expressionLbl.text = "0"
        decimalEntered = false
        runningValue = "0"
        result = "0"
        expression = ""
    }
}

