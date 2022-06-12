//
//  TodayView.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 12/06/2022.
//

import UIKit

class TodayView: StyleView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    func clearData() {
        dateLabel.text = ""
        cityLabel.text = ""
        weatherLabel.text = ""
        weatherImage.image = nil
    }
    
    func updateView(currentWeather: Current, city: String) {
        cityLabel.text = city
        dateLabel.text = Date.getTodaysDate()
        weatherLabel.text = currentWeather.weather[0].description.capitalized
        weatherImage.image = UIImage(named: currentWeather.weather[0].icon)
        dateLabel.textColor = UIColor.black
        cityLabel.textColor = UIColor.black
        weatherLabel.textColor = UIColor.black
    }

}
