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
    var didPressEqualBtn = false
    var startedExpression = false
    var enteringFirstValue = true
    

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
    }


    @IBAction func plusMinusBtnPressed(_ sender: UIButton) {
        playBtnSound()
        updateExpressionLbl(op: "^")
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        resetValues()
        playBtnSound()
    }
    
    private func buildTokens(infixStr: String) -> String {
        var array = [Token]()
        var token: Token!
        
        for str in infixStr.split(separator: " ") {
            let data = String(str)
                if let value = Double(data) {
                    token = Token(value: value)
                }
            
                if data == "+" { token = Token(operation: .addition)}
                if data == "-" { token = Token(operation: .subtraction)}
                if data == "*" { token = Token(operation: .multiplication)}
                if data == "/" { token = Token(operation: .division)}
                if data == "%" { token = Token(operation: .modulo)}
                if data == "^" { token = Token(operation: .exponent)}
                array.append(token)
        }
        
        return postFixBuilder(array)
    }
        
    @IBAction func equalBtnPressed(_ sender: UIButton) {
        
        let text = expressionLbl.text
        let postFixStr = buildTokens(infixStr: text!)
        print(postFixStr)
        if isValidPostFix(postFixStr) {
            tree = constructTree(str: postFixStr)
            let value = evaluateTree(tree)
            numberLbl.text = String(value)
        } else {
            numberLbl.text = "Syntax Error"
        }
       
    }
 
    
    @IBAction func moduloBtnPressed(_ sender: UIButton) {
        playBtnSound()
        updateExpressionLbl(op: "%")
        numberLbl.text = "0"
    }
    
    @IBAction func divideBtnPressed(_ sender: UIButton) {
        playBtnSound()
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
        playBtnSound()
        runningValue = "0"
    }
    
    @IBAction func numberBtnsPressed(_ sender: UIButton) {
        playBtnSound()
        
        if expressionLbl.text == "0" && sender.tag == 0 {
            expressionLbl.text = "0"
            
        }
        else if runningValue == "0" {
            if (sender.tag != 0) {
                runningValue = String(sender.tag)
                expression.append(runningValue)
                expressionLbl.text = expression
            } 
        } else {
            runningValue = String(sender.tag)
            expression.append(runningValue)
            expressionLbl.text = expression

        }
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
        didPressEqualBtn = false
        runningValue = "0"
        result = "0"
        expression = ""
    }
}

