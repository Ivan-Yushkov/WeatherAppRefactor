//
//  CurrentWeather.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//


import Foundation

struct CurrentWeather {
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature) + " C"
    }
    
    let feelsLikeTemperature: Double
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature) + " C"
    }
    
    let cityName: String
    
    let conditionCode: Int
    
    var conditionString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.smoke.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "clear"
            
        }
    }
    
    
    init?(fromCurrentWeatherData currentWeatherData: CurrentWeatherDataForParse) {
        self.temperature = currentWeatherData.main.temp
        self.feelsLikeTemperature = currentWeatherData.main.feelsLike
        self.cityName = currentWeatherData.name
        self.conditionCode = currentWeatherData.weather[0].id
    }
    
    
}
