//
//  ViewController.swift
//  DineSmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-04.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import CoreLocation
import PinFloyd
import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inspectionMapView: MKMapView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var centreButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var locationManager: CLLocationManager!
    
    let client = InspectionClient()
    let clusteringManager = ClusteringManager()
    let inspectionDictionary = InspectionDictionary()
    
    private struct Constants {
        static let ClusterAnnotationIdentifier = ClusterAnnotationView.identifier
        
        static let DetailSegue = "toDetailView"
        
        static let CentreMeters: Double = 400
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInteractionAllowed(to: false)
        
        inspectionMapView.delegate = self
        inspectionMapView.center()
        
        if !CLLocationManager.locationServicesEnabled()
            || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                centreButton.isHidden = true
        }
        
        // TODO: WIP
        client.inspections { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.setInteractionAllowed(to: true)
            
            switch result {
            case .success(let inspections):
                self.clusteringManager.add(annotations: inspections.compactMap { inspection in
                    guard let annotation = inspection.asMKAnnotation() else {
                        return nil
                    }
                    
                    self.inspectionDictionary.insert(annotation.coordinate.latitude, annotation.coordinate.longitude, value: inspection)
                    return annotation
                })
                
                self.clusteringManager.renderAnnotations(onMapView: self.inspectionMapView)
            case .failure:
                self.presentAlertWith(message: "API Request Failed")
            }
        }
    }
    
    @IBAction func centreButtonTapped(_ sender: Any) {
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: Constants.CentreMeters, longitudinalMeters: Constants.CentreMeters)
            inspectionMapView.setRegion(viewRegion, animated: false)
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
    }
    
    func setInteractionAllowed(to allowed: Bool) {
        inspectionMapView.isUserInteractionEnabled = allowed
        searchButton.isUserInteractionEnabled = allowed
        centreButton.isUserInteractionEnabled = allowed
        
        loadingLabel.isHidden = allowed
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusteringManager.renderAnnotations(onMapView: inspectionMapView)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        
        let annotations = (annotation as? ClusterAnnotation)?.heldAnnotations ?? [annotation]
        let inspections: [[InspectedLocation]] = annotations.compactMap { [weak self] annotation in
            guard let self = self, let locations = self.inspectionDictionary.locationsAt(annotation.coordinate.latitude, annotation.coordinate.longitude) else {
                return nil
            }
            
            return locations
        }
        
        var flatInspections = inspections.flatMap { $0 }
        flatInspections.removeDuplicates()
        
        performSegue(withIdentifier: Constants.DetailSegue, sender: flatInspections)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is ClusterAnnotation else {
            return nil
        }
        
        var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.ClusterAnnotationIdentifier)
        if clusterView == nil {
            clusterView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: Constants.ClusterAnnotationIdentifier)
        } else {
            clusterView?.annotation = annotation
        }
        
        return clusterView
    }
}
