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
    
    var loadedInspections: [MKPointAnnotation: InspectedLocation] = [:]
    
    var locationManager: CLLocationManager!
    let client = InspectionClient()
    let clusteringManager = ClusteringManager()
    
    private struct Constants {
        static let ClusterAnnotationIdentifier = ClusterAnnotationView.identifier
        static let DetailSegue = "toDetailView"
        static let InspectionSegue = "toInspectionView"
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
                    guard let annotation = inspection.asAnnotation() else {
                        return nil
                    }
                    
                    self.loadedInspections[annotation] = inspection
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
        performSegue(withIdentifier: Constants.DetailSegue, sender: nil)
    }
    
    func setInteractionAllowed(to allowed: Bool) {
        inspectionMapView.isUserInteractionEnabled = allowed
        searchButton.isUserInteractionEnabled = allowed
        
        centreButton.isUserInteractionEnabled = allowed
        if allowed {
            centreButton.center = CGPoint(x: centreButton.center.x, y: centreButton.center.y + 25)
        }
        
        loadingLabel.isHidden = allowed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == Constants.DetailSegue {
            guard let destination = segue.destination as? DetailViewController else {
                return
            }
        
            guard let selectedInspections = sender as? [InspectedLocation] else {
                destination.inspectedLocations = Array(loadedInspections.values)
                return
            }
        
            destination.inspectedLocations = selectedInspections
        } else if identifier == Constants.InspectionSegue {
            guard let destination = segue.destination as? InspectionViewController,
                let location = sender as? InspectedLocation else {
                    return
            }
            
            destination.inspectedLocation = location
        }
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
        
        guard let annotations = (annotation as? ClusterAnnotation)?.heldAnnotations else {
            guard let pointAnnotation = annotation as? MKPointAnnotation,
                let location = self.loadedInspections[pointAnnotation] else {
                    return
            }
            
            performSegue(withIdentifier: Constants.InspectionSegue, sender: location)
            return
        }
        
        let inspections: [InspectedLocation] = annotations.compactMap { [weak self] annotation in
            guard let self = self,
                let pointAnnotation = annotation as? MKPointAnnotation,
                let location = self.loadedInspections[pointAnnotation] else {
                    return nil
            }
            
            return location
        }
        
        performSegue(withIdentifier: Constants.DetailSegue, sender: inspections)
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
