//
//  WeatherData.swift
//  weatherApp
//
//  Created by Shubham Nayal on 05/11/21.
//

import Foundation
struct WeatherData: Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main: Decodable {
    let temp :Double
}

struct Weather : Decodable {
    let id : Int
}
