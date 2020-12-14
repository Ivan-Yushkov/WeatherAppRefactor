//
//  CeurrentWeatherDataForParse.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import Foundation

struct CurrentWeatherDataForParse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}


struct Weather: Codable {
    var id: Int
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
    
}
