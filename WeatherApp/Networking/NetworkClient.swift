//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import Foundation
import Alamofire

class NetworkClient {
    static let shared: NetworkClient = NetworkClient()
    let baseURL = "https://api.weatherbit.io/v2.0/"
    
    
    func getCurrentWeather(complition: @escaping (_ response: WeatherModel?) -> Void){
        let url = baseURL + WeatherService.getWeather(UserDefaults.standard.double(forKey: "lat") , UserDefaults.standard.double(forKey: "lon")).path
        
        AF.request(url, method: .get , parameters: WeatherService.getWeather(UserDefaults.standard.double(forKey: "lat") , UserDefaults.standard.double(forKey: "lon")).parameters, encoding: URLEncoding.default).responseDecodable(of: WeatherResponseModel.self) { response in
            complition(response.value?.data?[0])
        }
    }
    
    func getForecast(complition: @escaping (_ response: [WeatherModel]?) -> Void){
        let url = baseURL + WeatherService.getForecast(UserDefaults.standard.double(forKey: "lat"), UserDefaults.standard.double(forKey: "lon")).path
        AF.request(url, method: .get , parameters: WeatherService.getForecast(UserDefaults.standard.double(forKey: "lat"), UserDefaults.standard.double(forKey: "lon")).parameters, encoding: URLEncoding.default).responseDecodable(of: WeatherResponseModel.self) { response in
            complition(response.value?.data)
        }
        
    }
    
    
    
}
