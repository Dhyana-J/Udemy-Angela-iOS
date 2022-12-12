//
//  Calculator.swift
//  Calculator
//
//  Created by Kaala on 2022/12/09.
//  Copyright © 2022 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    private var number:Double?
    
    private var intermediateCalculation:(n1:Double, calcMethod:String)?
    
    mutating func setNumber(_ number:Double){
        self.number = number
    }
    
    mutating func calculate(_ symbol:String) -> Double?{
        if let number {
            switch symbol {
            case "AC" : return 0
            case "+/-" : return number * -1
            case "%" : return number * 0.01
            case "=":
                return performTwoNumberCalculation(n2:number)
            default:
                intermediateCalculation = (n1:number,calcMethod:symbol)
                return number
            }
        }
        return nil
    }
    
    private func performTwoNumberCalculation(n2:Double) -> Double? {
        if let n1 = intermediateCalculation?.n1, let operation = intermediateCalculation?.calcMethod {
            switch operation {
            case "+": return n1 + n2
            case "-": return n1 - n2
            case "×": return n1 * n2
            case "÷": return n1 / n2
            default:
                fatalError("The operation passed in does not match any of the cases.")
            }
        }
        return nil
    }
    
}
