//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 25.04.21.
//

import Foundation

class ForecastViewModel {

    var forecast : [WeatherModel]?
    
    
    func getForecast(complition: @escaping (_ hasResult: Bool?) -> Void){
        NetworkClient.shared.getForecast() { result in
            if let result = result {
                self.forecast = result
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(self.forecast)
                    UserDefaults.standard.set(data, forKey: "forecast")

                } catch {
                    print("Unable to Encode Array of Notes (\(error))")
                }
                complition(true)
            }else{
                complition(false)
            }
        }
    }
}
