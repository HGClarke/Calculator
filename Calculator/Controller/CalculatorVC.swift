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
    @IBOutlet var numberLbl: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var expressionLbl: UILabel!
    
    var tree = ExpressionTree()
    var result: String = ""
    var runningValue = ""
    let str = "100 + 23 - 99 * 45 * 77"
    let newStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtnSound()
    }


    @IBAction func plusMinusBtnPressed(_ sender: UIButton) {
        negateValue()
        playBtnSound()
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
                array.append(token)
            
        }
        
        return postFixBuilder(array)
    }
    
    private func isOperator(str: String) -> Bool {
        var isOperator = false
        
        if str == "*" { isOperator = true }
        if str == "/" { isOperator = true }
        if str == "+" { isOperator = true }
        if str == "%" { isOperator = true }
        if str == "-" { isOperator = true }
        
        return isOperator
    }
    
    private func createNewNode(str: String) -> ExpressionTree {
        let newNode = ExpressionTree()
        newNode.data = str
        return newNode
    }
    
    public func constructTree(str: String) -> ExpressionTree {
        
        var treeStack = Stack<ExpressionTree>()
        var t, t1, t2 : ExpressionTree
        
        for token in str.split(separator: " ") {
            let tokenToString = String(token)
            if (!isOperator(str: tokenToString)) {
                t = createNewNode(str: tokenToString)
                treeStack.push(t)
            } else {
                t = createNewNode(str: tokenToString)
                
                // Pop the two nodes from the stack
                // We know that we will have at least two variables in the stack because
                // the representation of the postfix will put the operator after the two digitis
                
                t1 = treeStack.peek()!
                _ = treeStack.pop()
                t2 = treeStack.peek()!
                _ = treeStack.pop()
                t.leftChild = t1
                t.rightChild = t2
                
                treeStack.push(t)
            }
        }
        t = treeStack.peek()!
        _ = treeStack.pop()
        
        return t
    }
    
    private func evaluateTree(_ tree: ExpressionTree?) -> Double {
        
        if tree == nil {
            return 0.0
        }
        if tree?.leftChild == nil && tree?.rightChild == nil {
            return Double(tree!.data) ?? 0
        }
        
        let leftVal = evaluateTree(tree?.leftChild)
        let rightVal = evaluateTree(tree?.rightChild)
        var ans: Double = 0
        
        if tree?.data == "+" { ans = calculator.add(leftVal, rightVal)}
        if tree?.data == "-" { ans = calculator.subtract(leftVal, rightVal)}
        if tree?.data == "*" { ans = calculator.multiply(leftVal, rightVal)}
        if tree?.data == "/" { ans = calculator.divide(leftVal, rightVal)}
        if tree?.data == "%" { ans = calculator.modulo(leftVal, rightVal)}
        return ans
    }
        
    @IBAction func equalBtnPressed(_ sender: UIButton) {
        performOperation(.addition)
        let text = numberLbl.text
        let postFixStr = buildTokens(infixStr: text!)
        tree = constructTree(str: postFixStr)
        print(evaluateTree(tree))

    }
    @IBAction func moduloBtnPressed(_ sender: UIButton) {
        performOperation(.modulo)
        
    }
    @IBAction func divideBtnPressed(_ sender: UIButton) {
        performOperation(.division)
    }
    @IBAction func multiplyBtnPressed(_ sender: UIButton) {
        performOperation(.multiplication)
    }
    
    @IBAction func subtractBtnPressed(_ sender: UIButton) {
        performOperation(.subtraction)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        performOperation(.addition)
        print(result)
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func numberBtnsPressed(_ sender: UIButton) {
        playBtnSound()
        // May have to change this due to now implementing running yard algorithm
        if numberLbl.text != "0" {
            runningValue.append(String(sender.tag))
            numberLbl.text = runningValue
        } else {
            numberLbl.text = String(sender.tag)
            runningValue = numberLbl.text!
        }
    }
    
    // If the text contains a negative value then make it a positive value
    // If the text contains a positive value then make it a negative value
    private func negateValue() {
        let text = numberLbl.text!
        var value = Double(text)!
        
        // if text value is 0 dont make any changes
        if value != 0 {
            value = value * -1.0
            numberLbl.text = String(value)
            result = numberLbl.text!
        }
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
    }
    
    private func performOperation(_ operation: Operations)  {
        playBtnSound()
    }
}

