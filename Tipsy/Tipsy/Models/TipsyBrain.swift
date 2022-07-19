//
//  TipsyBrain.swift
//  Tipsy
//
//  Created by Kaala on 2022/07/05.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct TipsyBrain {
    
    var totalBill:Float
    var tipAmount:Float
    var split:Int
    
    func calculateBill()-> String {
        let percentage:Float = 1 + tipAmount
        return String(format: "%.2f", totalBill * percentage / Float(split))
    }
    
    func tipAmountToPercentage()->String {
        return "\(Int(tipAmount*100))%"
    }
    
    
}
