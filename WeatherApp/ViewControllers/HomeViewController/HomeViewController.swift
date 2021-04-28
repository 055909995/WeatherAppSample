//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import UIKit
import SDWebImage
import CoreLocation
import CoreData


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperaureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!

    
    let viewModel = HomeViewModel()
    private var locationManager = CLLocationManager()
    let authState = CLLocationManager.authorizationStatus()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
        locationManager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDefaults.standard.string(forKey: "city") == nil {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        self.showAlert()
                    case .authorizedAlways, .authorizedWhenInUse:
                        locationManager.startUpdatingLocation()
                    @unknown default:
                    break
                }
                } else {
                    print("Location services are not enabled")
            }
        }else{
            self.getWeather()
        }
    }
    
    func getWeather() {
        self.showActivity(viewController: self)
        self.viewModel.getWeather(){ hasResult in
            if hasResult == true {
                if let range = self.viewModel.currentWeather!.timezone?.range(of: "/") {
                    let city = self.viewModel.currentWeather!.timezone?[range.upperBound...]
                    UserDefaults.standard.setValue(city, forKey: "city")
                }
                self.setWeather(weather: self.viewModel.currentWeather!)
            }else{
                if let currentWeatherData = UserDefaults.standard.data(forKey: "currentWeather") {
                    do {
                        let decoder = JSONDecoder()
                        let currentWeather = try decoder.decode(WeatherModel.self, from: currentWeatherData)
                        self.setWeather(weather: currentWeather)
                        self.hideActivity(viewController: self)
                    } catch {
                        print("Unable to Decode currentWeatherData (\(error))")
                    }
                }
            }
        }
    }
    
    
    func setWeather(weather: WeatherModel){
        self.temperaureLabel.text = String((weather.temp)!) + "°C"
        let imgUrl = "https://www.weatherbit.io/static/img/icons/" + (weather.weather?.icon)! + ".png"
        self.weatherIconImageView.sd_setImage(with: URL(string: imgUrl))
        self.weatherDescriptionLabel.text = weather.weather?.weatherDescription
        self.cityNameLabel.text = UserDefaults.standard.string(forKey: "city")
        self.hideActivity(viewController: self)
    }
    

    
    func showAlert(){
        let alert = UIAlertController(title: "Notice", message: "Please enable location services , or select your city from the list in settings ", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Enable location services", style: UIAlertAction.Style.default, handler: { action in
            self.requestAuthorization()
        }))
        alert.addAction(UIAlertAction(title: "Select city", style: UIAlertAction.Style.default, handler: { action in
            self.tabBarController?.selectedIndex = 2
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse  else {
            if UserDefaults.standard.string(forKey: "city") == nil {
                self.showAlert()
            }
            return
        }
    }
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "lon")
        self.getWeather()
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error
    ) {
        print(error)
    }
    
    
    func requestAuthorization() {
        
        if self.authState != .authorizedWhenInUse {
            
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified, please open this app's settings and set location access to 'When in use'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL)
                }
            }
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}


