//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Le Dat on 6/2/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var link : String!
    var location : String!
    var lat : Double!
    var long : Double!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Convert location to lat/lon
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location!) { (placemarks, error) in
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.long = placemark?.location?.coordinate.longitude
            
            let coordinate = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)
            let first = MapClient.Auth.firstName
            let last = MapClient.Auth.lastName
            let mediaURL = self.link!
            
            // Create annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            self.mapView.addAnnotation(annotation)
            
            //zooming in annotation
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50 * 1609.34, longitudinalMeters: 50 * 1609.34)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func finishTapped(_ sender: UIButton) {
        MapClient.postStudentLocation(key: MapClient.Auth.userId, firstName: MapClient.Auth.firstName, lastName: MapClient.Auth.lastName, mapString: location, mediaURL: link, lat: lat, long: long) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error putting student location")
            }
        }
    }
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let mediaURL = view.annotation?.subtitle!{
                if mediaURL.contains("http"){
                    if let url = URL(string: mediaURL){
                        app.open(url, options: [:], completionHandler: nil)
                    }
                }else{
                    showAlert(ofTitle: "Open Failed", message: "Incorrect URL")
                }
            }
        }
    }
    
    func showAlert(ofTitle: String, message : String){
        let alertVC = UIAlertController(title: ofTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
