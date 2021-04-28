//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 23.04.21.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var forecastTableView: UITableView!
    let viewModel = ForecastViewModel()
    var forecast : [WeatherModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self

        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.showActivity(viewController: self)
        self.viewModel.getForecast() { hasResult in
            if hasResult == true {
                self.hideActivity(viewController: self)
                self.forecast = self.viewModel.forecast
                self.forecastTableView.reloadData()
            }else{
                if let forecastData = UserDefaults.standard.data(forKey: "forecast") {
                    do {
                        let decoder = JSONDecoder()
                        let forecast = try decoder.decode([WeatherModel].self, from: forecastData)
                        self.forecast = forecast
                        self.forecastTableView.reloadData()
                        self.hideActivity(viewController: self)
                    } catch {
                        print("Unable to Decode forecastData (\(error))")
                    }
                }
            }
        }
    }
}



//MARK:- UITableViewDelegate , UITableViewDataSource
extension ForecastViewController : UITabBarDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier:"ForecastTableViewCell") as! ForecastTableViewCell
        let oneItem = self.forecast![indexPath.row]
        cell.configureCell(icon: (oneItem.weather?.icon!)!, temp: String(oneItem.temp!), date: oneItem.validDate!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
