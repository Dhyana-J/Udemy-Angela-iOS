//
//  BTCModel.swift
//  ByteCoin
//
//  Created by Kaala on 2022/07/20.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

// 화면에 뿌려줄 데이터 모델

struct BTCModel {
    let time:String
    let currency:String
    let currentPrice:Double
    var priceString:String {String(format: "%.2f", currentPrice)}
    
}
