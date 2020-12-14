//
//  NetworkService.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//
import Foundation
import Alamofire
import RxSwift
import CoreLocation

enum RequestType {
    case RequestByCity (city: String)
    case RequestByLocation (longitude: CLLocationDegrees, latitude: CLLocationDegrees)
}


protocol NetworkServiceProtocol: class {
    func getDataWeather(type: RequestType) -> Single<CurrentWeather?>
}

class NetworkService: NetworkServiceProtocol {
   
    
    func getDataWeather(type: RequestType) -> Single<CurrentWeather?> {
        var data = [String: Any]()
        switch type {
        case .RequestByCity(city: let city):
            data = [
                "q": city,
                "cnt": 24,
                "units": "metric",
                "appid": SittintWeatherRouter.apiKey
            ]
        case .RequestByLocation(longitude: let longitude,
                                latitude: let latitude):
            data = ["lat": "\(latitude)",
                    "lon": "\(longitude)",
                    "cnt": 24,
                    "units": "metric",
                    "appid": SittintWeatherRouter.apiKey
            ]
        }
        
        
        let routing = WeatherRouter.getWeatherData(data)
        return Single.create { (single) -> Disposable in
            let request = AF.request(routing).responseData { (response) in
                let statuseCode = response.response?.statusCode
                print(statuseCode)
                switch response.result {
                case .success(let value):
                    do {
                        print(value)
                        let jsonObject = try JSONDecoder().decode(CurrentWeatherDataForParse.self, from: value)
                        let currentWeater = CurrentWeather(fromCurrentWeatherData: jsonObject)
                        single(.success(currentWeater))
                    } catch let error {
                        single(.error(error))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
