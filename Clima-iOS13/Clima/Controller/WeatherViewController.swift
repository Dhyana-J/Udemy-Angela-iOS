//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
//    var currentLocation:(CLLocationDegrees,CLLocationDegrees)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
//        if let lat = currentLocation?.0, let lon = currentLocation?.1 {
//            weatherManager.fetchWeather(latitude: lat, longitude: lon)
//        }
    }
    
    
    
}


//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // keyboard return button 누르면 실행
        print(#function)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // shouldReturn or searchPressed 이후 실행
        print(#function)
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController:WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel){
        DispatchQueue.main.async { // 화면에 대한 update는 반드시 main thread에서 해야함. main thread에서 화면그리는 작업이 이루어짐
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
//            currentLocation = (lat,lon)
            weatherManager.fetchWeather(latitude:lat,longitude:lon)
        }
    }
    
}

