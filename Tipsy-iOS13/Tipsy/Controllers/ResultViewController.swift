//
//  ResultViewController.swift
//  Tipsy
//
//  Created by Kaala on 2022/07/05.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var tipsyBrain:TipsyBrain?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalLabel.text = tipsyBrain?.calculateBill() ?? "try again"
        settingsLabel.text = "Split between \(tipsyBrain?.split ?? 0) people, with \((tipsyBrain?.tipAmountToPercentage())!) tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
