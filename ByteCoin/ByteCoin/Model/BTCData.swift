//
//  BTCData.swift
//  ByteCoin
//
//  Created by Kaala on 2022/07/20.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

// API로 가져올 데이터 모델

struct BTCData:Codable{
    let time:String
    let rate:Double
    let asset_id_quote:String
}
