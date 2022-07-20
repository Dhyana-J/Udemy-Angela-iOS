//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager:CoinManager, btcData:BTCModel)
    func didFailWithError(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "180DE3EC-230A-478E-96AA-972F6379415F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate:CoinManagerDelegate?

    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String){
        // 1. url
        // 2. create session
        // 3. datatask setting
        // 4. resume
        if let url = URL(string:urlString) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let btcInfo = self.parseJSON(safeData){
                        delegate?.didUpdatePrice(self, btcData: btcInfo)
                    }
                }
            }.resume()
        }
    }
    
    
    func parseJSON(_ btcData:Data)->BTCModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BTCData.self, from: btcData)
            let time = decodedData.time
            let price = decodedData.rate
            let currency = decodedData.asset_id_quote
            let btcInfo = BTCModel(time: time, currency: currency, currentPrice: price)
            return btcInfo
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
