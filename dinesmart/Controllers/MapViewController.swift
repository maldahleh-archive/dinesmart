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

class MapViewController: UIViewController {
    @IBOutlet weak var inspectionMapView: MKMapView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var centreButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var loadedInspections: [MKPointAnnotation: InspectedLocation] = [:]
    
    let apiClient = InspectionClient()
    let clusteringManager = ClusteringManager()
    let locationManager = CLLocationManager()
    let persistence = PersistenceService()
    
    private struct Constants {
        static let ClusterAnnotationIdentifier = ClusterAnnotationView.identifier
        static let DetailSegue = "toDetailView"
        static let InspectionSegue = "toInspectionView"
        static let CentreMeters = 400.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationServices()
        setInteractionAllowed(to: false)
        
        inspectionMapView.delegate = self
        inspectionMapView.center()
        
        updateInspections()
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

// MARK: - Networking
extension MapViewController {
    typealias InspectionsCompletionHandler = ([InspectedLocation]?) -> Void
    
    private func retrieveInspections(_ completion: @escaping InspectionsCompletionHandler) {
        apiClient.inspections { result in
            switch result {
            case .success(let inspections):
                completion(inspections)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func updateInspections() {
        retrieveInspections { [weak self] inspections in
            guard let self = self else {
                return
            }
            
            guard let inspections = inspections else {
                self.presentAPIError { [weak self] _ in
                    guard let self = self else {
                        return
                    }
                    
                    self.updateInspections()
                }
                
                return
            }
            
            self.setInteractionAllowed(to: true)
            self.clusteringManager.add(annotations: inspections.compactMap { inspection in
                guard let annotation = inspection.asAnnotation() else {
                    return nil
                }
                
                self.loadedInspections[annotation] = inspection
                return annotation
            })
            
            self.clusteringManager.renderAnnotations(onMapView: self.inspectionMapView)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusteringManager.renderAnnotations(onMapView: inspectionMapView)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let userLocation = mapView.view(for: mapView.userLocation) else {
            return
        }
        
        userLocation.isEnabled = false
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
            
            mapView.deselectAnnotation(pointAnnotation, animated: false)
            performSegue(withIdentifier: Constants.InspectionSegue, sender: location)
            return
        }
        
        performSegue(withIdentifier: Constants.DetailSegue, sender: annotations.compactMap { [weak self] annotation in
            guard let self = self,
                let pointAnnotation = annotation as? MKPointAnnotation,
                let location = self.loadedInspections[pointAnnotation] else {
                    return nil
            }
            
            return location
        } as [InspectedLocation])
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

// MARK: - Location
extension MapViewController {
    private func setupLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            centreButton.isHidden = true
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centreButton.isHidden = status != .authorizedWhenInUse
    }
}
