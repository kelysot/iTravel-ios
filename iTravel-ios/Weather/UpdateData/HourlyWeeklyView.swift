//
//  HourlyWeeklyView.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 12/06/2022.
//

import UIKit

class HourlyWeeklyView: StyleView {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topLabel1: UILabel!
    @IBOutlet weak var topLabel2: UILabel!
    @IBOutlet weak var topLabel3: UILabel!
    @IBOutlet weak var topLabel4: UILabel!
    @IBOutlet weak var topLabel5: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    
    @IBOutlet weak var bottomLabel1: UILabel!
    @IBOutlet weak var bottomLabel2: UILabel!
    @IBOutlet weak var bottomLabel3: UILabel!
    @IBOutlet weak var bottomLabel4: UILabel!
    @IBOutlet weak var bottomLabel5: UILabel!
    
    func clearData() {
        let labels = [topLabel1, topLabel2, topLabel3, topLabel4, topLabel5, bottomLabel1, bottomLabel2, bottomLabel3, bottomLabel4, bottomLabel5]
        let images = [imageView1, imageView2, imageView3, imageView4, imageView5]
        
        for label in labels {
            label?.text = ""
        }
        for image in images {
            image?.image = nil
        }
    }
    
    func updateViewForToday(_ hourly: [Hourly]) {
        updateHours(hourly: hourly)
    }
    
    func updateViewForWeekly(_ daily: [Daily]) {
        updateDays(daily: daily)
    }
    
    func getSelectedTitle() -> String {
        let index = segmentedControl.selectedSegmentIndex
        let title = segmentedControl.titleForSegment(at: index) ?? ""
        
        return title
        
    }
    
    func updateHours(hourly: [Hourly]) {
        let topLabels = [topLabel1, topLabel2, topLabel3, topLabel4, topLabel5]
        let bottomLabels = [bottomLabel1, bottomLabel2, bottomLabel3, bottomLabel4, bottomLabel5]
        let images = [imageView1, imageView2, imageView3, imageView4, imageView5]
        
        for i in 0...4 {
            
            let hour = hourly[i + 1]
            let date = Date(timeIntervalSince1970: Double(hour.dt))
            let hourString = Date.getHourFrom(date: date)
            let weatherIconName = hour.weather[0].icon
            let weatherTemperature = hour.temp
            let celsiusWeatherTemperature = convertToCelsius(fahrenheit: Int(weatherTemperature))
            
            topLabels[i]?.text = hourString
            images[i]?.image = UIImage(named: weatherIconName)
            bottomLabels[i]?.text = "\(celsiusWeatherTemperature)°C"
            bottomLabels[i]?.textColor = UIColor.black
            topLabels[i]?.textColor = UIColor.black

        }
        
    }
    
    func updateDays(daily: [Daily]) {
        let topLabels = [topLabel1, topLabel2, topLabel3, topLabel4, topLabel5], bottomLabels = [bottomLabel1, bottomLabel2, bottomLabel3, bottomLabel4, bottomLabel5], images = [imageView1, imageView2, imageView3, imageView4, imageView5]
        for i in 0...4 {
            
            let day = daily[i + 2]
            let date = Date(timeIntervalSince1970: Double(day.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            let dayString = dateFormatter.string(from: date)
            let weatherIconName = day.weather[0].icon
            let weatherTemperature = day.temp.day
            let celsiusWeatherTemperature = convertToCelsius(fahrenheit: Int(weatherTemperature))
            
            topLabels[i]?.text = dayString
            images[i]?.image = UIImage(named: weatherIconName)
            bottomLabels[i]?.text = "\(celsiusWeatherTemperature)°C"
        }
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}
