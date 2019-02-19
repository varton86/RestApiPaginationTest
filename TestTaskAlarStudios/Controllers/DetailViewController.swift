//
//  DetailViewController.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 29.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    var airport: Airport!

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Airport"
        idLabel.text = airport.id
        nameLabel.text = airport.name
        countryLabel.text = airport.country
        latitudeLabel.text = String(airport.lat)
        longitudeLabel.text = String(airport.lon)

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(airport.lat, airport.lon)

        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)

        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        let theRegion = mapView.regionThatFits(region)
        mapView.setRegion(theRegion, animated: true)
    }
    
    deinit {
        print("*** Deinit Detail ...")
    }

}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.pinTintColor = UIColor.red
            annotationView = pinView
        }
        return annotationView
    }
}

