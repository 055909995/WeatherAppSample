//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 25.04.21.
//

import UIKit
import SDWebImage

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(icon: String , temp: String, date: String){
        self.dateLabel.text = date
        self.weatherTemperatureLabel.text = temp + "°C"
        let imgUrl = "https://www.weatherbit.io/static/img/icons/" + icon + ".png"
        self.weatherIconImageView.sd_setImage(with: URL(string: imgUrl))
    }


}
