//
//  WeatherViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 12/06/2022.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var todayView: TodayView!
    @IBOutlet weak var hourlyWeeklyView: HourlyWeeklyView!
    @IBOutlet weak var refreshBtn: StyleViewButton!
    
    
    var city = ""
    var weatherResult: Result?
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshBtn.backgroundColor = UIColor.white
        refreshBtn.tintColor = UIColor.black
        clearAll()
        getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearAll()
        getLocation()
    }
    
    func clearAll() {
        todayView.clearData()
        hourlyWeeklyView.clearData()
    }
    
    func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.weatherResult = result
            
            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()
            
            self.updateViews()
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func updateViews() {
        updateTopView()
        updateBottomView()
    }
    
    func updateTopView() {

        guard let weatherResult = weatherResult else {
            return
        }
        
        todayView.updateView(currentWeather: weatherResult.current, city: city)
    }
    
    func updateBottomView() {

        guard let weatherResult = weatherResult else {
            return
        }
        
        let title = hourlyWeeklyView.getSelectedTitle()
        
        if title == "Today" {
            hourlyWeeklyView.updateViewForToday(weatherResult.hourly)
        } else if title == "Weekly" {
            hourlyWeeklyView.updateViewForWeekly(weatherResult.daily)
        }
    }
    
    func getLocation() {

        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            self.currentlocation = location
            
            let latitude: Double = self.currentlocation!.coordinate.latitude
            let longitude: Double = self.currentlocation!.coordinate.longitude
            
            NetworkService.shared.setLatitude(latitude)
            NetworkService.shared.setLongitude(longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.city = city
                        }
                    }
                }
            }
            
            getWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    
    @IBAction func getWeatherTapped(_ sender: Any) {
        clearAll()
        getLocation()
    }
  
    
    @IBAction func todayWeeklyValueChanged(_ sender: Any) {
        clearAll()
        updateViews()
    }
    

}
