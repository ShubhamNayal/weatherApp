//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Shubham Nayal on 05/11/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather : WeatherModel)
    func didFailError(error : Error)
}

struct WeatherManager {
    let weatherApi : String = "https://api.openweathermap.org/data/2.5/weather?appid=06293bd128ed4c6a0fd7ba180754814f&units=metric&"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName :String)  {
        let urlString = "\(weatherApi)q=\(cityName)"
        perfomRequest(urlString: urlString)
    }
    func fetchWeather(latitude : CLLocationDegrees,logitude : CLLocationDegrees) {
        let urlString = "\(weatherApi)lat=\(latitude)&lon=\(logitude)"
       // print(urlString)
        perfomRequest(urlString: urlString)
    }
    
    
    func perfomRequest(urlString : String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data {
                    if  let weather = parseJSON(weatcherData: safeData){
                        delegate?.didUpdateWeather(weather : weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(weatcherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatcherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            return weatherModel
            //  let weatherIcon = getConditionName(weatherId: id)
         //   print(weatherModel.tempratureString)
            
        }catch{
            delegate?.didFailError(error: error)
            return nil
        }
    }
    
    
}
