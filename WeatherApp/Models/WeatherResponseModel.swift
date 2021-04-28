//
//  WeatherResponseModel.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import Foundation

// MARK: - WeatherResponseModel
struct WeatherResponseModel: Codable {
    let data: [WeatherModel]?
    let cityName, timezone: String?
    let countryCode, stateCode: String?
    
    
    enum CodingKeys: String, CodingKey {
        case data
        case cityName = "city_name"
        case timezone
        case countryCode = "country_code"
        case stateCode = "state_code"
    }
}

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let validDate: String?
    let weather: WeatherDescriptionModel?
    let temp: Double?
    let cityName, timezone: String?

    enum CodingKeys: String, CodingKey {
        case validDate = "valid_date"
        case weather, temp
        case cityName = "city_name"
        case timezone
    }
}

// MARK: - WeatherDescriptionModel
struct WeatherDescriptionModel: Codable {
    let icon: String?
    let code: Int?
    let weatherDescription: String?

    enum CodingKeys: String, CodingKey {
        case icon, code
        case weatherDescription = "description"
    }
}
