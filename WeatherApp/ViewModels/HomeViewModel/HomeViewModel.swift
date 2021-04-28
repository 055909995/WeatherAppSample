//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import Foundation


class HomeViewModel {
    
    var currentWeather : WeatherModel?
    
    func getWeather(complition: @escaping (_ hasResult: Bool?) -> Void){
        NetworkClient.shared.getCurrentWeather() { result in
            if let result = result {
                self.currentWeather = result
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(result)
                    UserDefaults.standard.set(data, forKey: "currentWeather")
                } catch {
                    print("Unable to Encode (\(error))")
                }
                complition(true)
            }else{
                complition(false)
            }
        }
    }
}
