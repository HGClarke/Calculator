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
    @IBOutlet var allCalculationsLbl: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
    
    var leftVal: Double = 0
    var rightVal: Double = 0
    var leftValStr: String = ""
    var rightValStr: String = ""
    
    var runningValue = ""
    var result = ""
    var hasDecimal = false
    var currentOperation = Operations.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtnSound()
    }

    @IBAction func plusMinusBtnPressed(_ sender: UIButton) {
        negateValue()
        performOperation(.plusMinus)
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        resetValues()
        playBtnSound()
    }
    
    @IBAction func equalBtnPressed(_ sender: UIButton) {
        performOperation(currentOperation)

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
        runningValue = ""
        leftVal = 0
        rightVal = 0
        leftValStr = ""
        rightValStr = ""
        currentOperation = .empty
    }
    
    
    private func performOperation(_ operation: Operations)  {
        playBtnSound()
    }
}

