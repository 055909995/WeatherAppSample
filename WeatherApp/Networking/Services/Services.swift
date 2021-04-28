//
//  Services.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import Foundation
import Alamofire

public enum WeatherService {
    case getWeather(Double,Double)
    case getForecast(Double,Double)
}

extension WeatherService: TargetType {
    
    var parameters: Parameters {
        switch self {
        case .getWeather(let lat, let lon):
            return ["lat": lat, "lon": lon, "key": "432f73e6556b4b2395d0d0fb15dc5b43", "lang": "ru"] as Parameters
        case .getForecast(let lat, let lon):
            return ["lat": lat, "lon": lon, "key": "432f73e6556b4b2395d0d0fb15dc5b43", "lang": "ru"] as Parameters
        }
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "current"
        case .getForecast:
            return "forecast/daily"
        }
    }
}


protocol TargetType {
    var path: String { get }
    var parameters: Parameters {get}
}
