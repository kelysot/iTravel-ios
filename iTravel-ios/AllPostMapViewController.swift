//
//  AllPostMapViewController.swift
//  iTravel-ios
//
//  Created by Adi Amoyal on 18/07/2022.
//

import UIKit
import MapKit


class AllPostMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var refreshControl = UIRefreshControl()
    var locationManager:CLLocationManager!
    var data = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString("Loading List...")
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()

    }
    
    @objc func reload(){
        if self.refreshControl.isRefreshing == false {
            self.refreshControl.beginRefreshing()
        }
        var alreadyThere = Set<Post>()
        if alreadyThere.count == 0{
            self.refreshControl.endRefreshing()
        }
        Model.instance.getAllPosts(){
            posts in
            for post in posts {
                let status = String(post.isPostDeleted!)
                
                if status.elementsEqual("false"){
                    alreadyThere.insert(post)
                }
            }

            self.data = [Post]()
            
            for idx in alreadyThere.indices {
                let p = alreadyThere[idx]
                self.data.append(p)
            }
            self.data.sort(by: { $0.lastUpdated > $1.lastUpdated })
            self.addAnnotations()
            self.refreshControl.endRefreshing()
        }
    }
    
    func addAnnotations() {
        for post in self.data {
            let status = String(post.isPostDeleted!)
            if status.elementsEqual("false"){
                print("post.coordinate")
                let latitude = Double(post.coordinate?.split(separator: ",", maxSplits: 1)[0] ?? "0")!
                let longitude = Double(post.coordinate?.split(separator: ",", maxSplits: 1)[1] ?? "0")!
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let pin = MKPointAnnotation()
                pin.coordinate = coordinate
                pin.title = "\(post.location ?? "")"
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
    }

}
