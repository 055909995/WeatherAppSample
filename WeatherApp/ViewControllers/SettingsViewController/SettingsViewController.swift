//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, UIDocumentPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {

    let authState = CLLocationManager.authorizationStatus()
    let array = ["Yerevan", "Moscow", "Tbilisi", "Kyiv", "California", "Paris", "London", "Prague", "Madrid", "Minsk", "Athens"]
    let locationManager = CLLocationManager()
    @IBOutlet weak var cityPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(array)
        self.cityPicker.delegate = self
        self.cityPicker.dataSource = self
        self.cityPicker.translatesAutoresizingMaskIntoConstraints = false
        locationManager.delegate = self
    }
    
    
    
    
    
    
    @IBAction func syncButtonTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() && authState != CLAuthorizationStatus.denied{
            UserDefaults.standard.set(nil, forKey: "city")
            self.showSuccess()
        }else{
            self.showAlert()
        }
    }
    
    func showSuccess(){
        let alert = UIAlertController(title: "Seuccess", message: "City sync success", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Notice", message: "Unable to get location , please turn on location services", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Enable location services", style: UIAlertAction.Style.default, handler: { action in
            self.requestAuthorization()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: array[row],attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCoordinateFrom(address: array[row]) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            UserDefaults.standard.set(self.array[row], forKey: "city")
            UserDefaults.standard.set(coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(coordinate.longitude, forKey: "lon")
        }
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
