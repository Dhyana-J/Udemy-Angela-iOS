//
//  WeatherManager.swift
//  Clima
//
//  Created by Kaala on 2022/07/13.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
        let API_KEY = "your_api_key"
    var weatherURL:String { "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(API_KEY)" }
    
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with:urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with:urlString)
    }
    
    func performRequest(with urlString:String){
        // 1. Create a URL
        // 2. Create a URL Session
        // 3. Give the session a task
        // 4. Start the task
        
        if let url = URL(string: urlString) { // 1
            let session = URLSession(configuration: .default) // 2
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            } // 3
            task.resume() // 4
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


