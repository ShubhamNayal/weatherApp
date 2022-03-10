//
//  ViewController.swift
//  weatherApp
//
//  Created by Shubham Nayal on 04/11/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet private weak var SearchCityTextFeild: UITextField!
    @IBOutlet weak var currentLoctionButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var weatcherIcon: UIImageView!
    @IBOutlet weak var tempratureText: UILabel!
    @IBOutlet weak var cityName: UILabel!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        SearchCityTextFeild.delegate = self
    }
    
    @IBAction private func backToCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - UITextFeild

extension ViewController : UITextFieldDelegate{
    @IBAction func searchCityButtonAction(_ sender: UIButton) {
        SearchCityTextFeild.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchCityTextFeild.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.text = "Type Something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = SearchCityTextFeild.text {
            weatherManager.fetchWeather(cityName: city)
        }
        SearchCityTextFeild.text = ""
    }
}


//MARK: - WeatherManager
extension ViewController : WeatherManagerDelegate{
    func didUpdateWeather(weather :WeatherModel){
        DispatchQueue.main.async { [self] in
            tempratureText.text = "\(weather.tempratureString)°C"
            weatcherIcon.image = UIImage(systemName: weather.conditionName)
            cityName.text = weather.cityName
        }
    }
    func didFailError(error : Error){
        print(error)
        
    }
}


//MARK: - CCLocation

extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let loction = locations.last{
        locationManager.stopUpdatingLocation()
        let log = loction.coordinate.longitude
        let lat = loction.coordinate.latitude
        weatherManager.fetchWeather(latitude : lat, logitude : log)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
