//
//  WeatherRouter.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import Foundation
import Alamofire

class SittintWeatherRouter {
    static let mainPath = "https://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "6e4cccc00efdf57bfcf1a5a28d53e453"
}

public enum WeatherRouter: URLRequestConvertible {
   
    case getWeatherData([String: Any])
    
    public func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getWeatherData:
                return .get
            }
        }
        let params: ([String: Any]?) = {
            switch self {
            case .getWeatherData(let json):
                return json
            }
        }()
        let url: URL = {
            let url = URL(string: SittintWeatherRouter.mainPath)!
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: params)
    }
}
