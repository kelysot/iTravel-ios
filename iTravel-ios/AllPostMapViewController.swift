//
//  AllPostMapViewController.swift
//  iTravel-ios
//
//  Created by Adi Amoyal on 18/07/2022.
//

import UIKit
import MapKit


class MyAnnotation: NSObject, MKAnnotation{
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let id: String?
//    let type: String

    init(coordinate: CLLocationCoordinate2D,
         title: String, subtitle: String, id: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.id = id
//        self.type = type
    }
    
//    var markerTintColor: UIColor  {
//        switch type {
//        case "CLASS":
//            return .red
//        case "LAB":
//            return .cyan
//        default:
//            return .green
//        }
//    }
}
//
class MyAnnotationView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation? {
        willSet {
            guard let myAnno = newValue as? MyAnnotation else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

//            markerTintColor = myAnno.markerTintColor
            glyphImage = UIImage(named: "icons8-apple-logo-30")
        }
    }
}

class AllPostMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var refreshControl = UIRefreshControl()
    var locationManager:CLLocationManager!
    var currentlocation: CLLocation?
    var city = ""
    var data = [Post]()
    var postId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MyAnnotation")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString("Loading List...")
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()
//        getLocation()
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
                let latitude = Double(post.coordinate?.split(separator: ",", maxSplits: 1)[0] ?? "0")!
                let longitude = Double(post.coordinate?.split(separator: ",", maxSplits: 1)[1] ?? "0")!
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
//                let pin = MKPointAnnotation()
//                pin.coordinate = coordinate
//                pin.title = "\(post.location ?? "")"
                let pin = MyAnnotation(coordinate: coordinate, title: "\(post.location ?? "")", subtitle: "\(post.userName ?? "")", id: "\(post.id ?? "")")
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
//    func getLocation() {
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            self.currentlocation = location
//
//            let latitude: Double = self.currentlocation!.coordinate.latitude
//            let longitude: Double = self.currentlocation!.coordinate.longitude
//
//            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//
//            mapView.setRegion(mRegion, animated: true)
//        }
//    }
    
    func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let annotation = annotation as? MyAnnotation else {
            return nil
        }
        
        var view: MKMarkerAnnotationView
        if let dview = mapView.dequeueReusableAnnotationView(withIdentifier: "MyAnnotation") as? MKMarkerAnnotationView{
            view = dview
        }else{
            view = MyAnnotationView(annotation: annotation, reuseIdentifier: "MyAnnotation")
        }
        return view
    }
    
    func mapView(_ mapView:MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped: UIControl){
        guard let annotation = annotationView.annotation as? MyAnnotation else{
            return
        }
        NSLog("annotation accessort click:  \(annotation.subtitle)")
        self.postId = annotation.id!
        performSegue(withIdentifier: "openPostDetails", sender: self)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPostDetails"){
            let dvc = segue.destination as! PostDetailsViewController
            for post in self.data {
                if self.postId.elementsEqual(post.id!){
                    dvc.post = post
                }
            }
        }
    }

}
