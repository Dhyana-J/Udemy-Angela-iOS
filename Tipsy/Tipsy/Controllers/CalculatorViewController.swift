//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctBtn: UIButton!
    @IBOutlet weak var tenPctBtn: UIButton!
    @IBOutlet weak var twentyPctBtn: UIButton!
    
    var billAmount:Float?
    var tipAmount:Float?
    var splitCount:Int?
    
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    
    @IBAction func tipChanged(_ sender: UIButton) {
        [zeroPctBtn,tenPctBtn,twentyPctBtn].forEach { button in
            button?.isSelected = false
        }
        sender.isSelected = true
        tipAmount = textToDecimal(sender.currentTitle!)
    }
    
    
    func textToDecimal(_ text:String)->Float{
        var amountString = text
        amountString.removeLast()
        return Float(amountString)! / 100
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let count = sender.value
        splitNumberLabel.text = String(Int(count))
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let splitNumber = splitNumberLabel.text!
        let tempText = billTextField.text!
        [zeroPctBtn,tenPctBtn,twentyPctBtn].forEach { btn in
            if btn?.isSelected == true {
                tipAmount = textToDecimal(btn?.currentTitle! ?? "0%")
            }
        }
        splitCount = Int(splitNumber)
        billAmount = Float(tempText)
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            if let tipAmount = tipAmount, let splitCount = splitCount, let billAmount = billAmount {
                destinationVC.tipsyBrain = TipsyBrain(totalBill: billAmount, tipAmount: tipAmount, split: splitCount)
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        billTextField.endEditing(true)
    }
    
    
    
    
    
}

