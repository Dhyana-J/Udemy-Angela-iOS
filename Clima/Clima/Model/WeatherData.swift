//
//  WeatherData.swift
//  Clima
//
//  Created by Kaala on 2022/07/14.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


// API로 가져올 데이터 모델
struct WeatherData:Codable { // Decodable, Encodable 은 JSON에서 파싱 위해 필요함
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Codable {
    let temp:Double
}

struct Weather:Codable{
    let id:Int
    let description:String
}
