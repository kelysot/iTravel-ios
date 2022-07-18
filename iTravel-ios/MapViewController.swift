//
//  SearchLocationViewController.swift
//  iTravel-ios
//
//  Created by Adi Amoyal on 16/07/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var delegate: AddPostViewController?
    
    @IBOutlet weak var searchTv: UITextField!
    @IBOutlet weak var locationTv: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var currentLocation = ""
    var currentCoordinate = ""
    var prevLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        
        // Design UI
        searchTv.layer.cornerRadius = 0
        searchTv.setLeftPaddingPoints(15)
        searchTv.setRightPaddingPoints(15)
        
        locationTv.layer.cornerRadius = 0
        addLocationBtn.layer.cornerRadius = 0
        searchBtn.layer.cornerRadius = 0
    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        let destination = searchTv.text!
        if destination != "" {
            searchForDestination(destination: destination)
        } else {
            showAlert(msg: "Please enter Your destination")
        }
    }
    
    @IBAction func addLocationBtn(_ sender: UIButton) {
        self.delegate?.setLocation(location: currentLocation, coordinate: currentCoordinate)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        if prevLocation == nil || prevLocation!.distance(from: newLocation) > 100 {
            getLocationInfo(location: newLocation)
        }
    }
    
    func getLocationInfo(location: CLLocation) {
        prevLocation = location
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [self] places, error in
            guard let place = places?.first, error == nil else {
                return
            }
            
            self.currentLocation = "\(place.name ?? "No data"), \(place.country ?? "")"
            self.locationTv.text = "\(place.name ?? "No data"), \(place.country ?? "")"
            self.currentCoordinate = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        }
    }
    
    func searchForDestination(destination: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(destination) { places, error in
            guard let place = places?.first, error == nil else {
                self.showAlert(msg: "No data to display")
                return
            }
            
            guard let location = place.location else {return}
            self.searchTv.text = ""
            
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = "\(place.name)"
            pin.subtitle = "\(place.country)"
            self.mapView.addAnnotation(pin)
            
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        present(alert, animated: true, completion: nil)
    }

}
