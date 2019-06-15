//
//  ViewController.swift
//  DineSmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-04.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import PinFloyd
import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inspectionMapView: MKMapView!
    
    let client = InspectionClient()
    let clusteringManager = ClusteringManager()
    
    private struct Constants {
        static let LATITUDE = 43.8563
        static let LONGITUDE = -79.5085
        static let DELTA = 0.7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inspectionMapView.delegate = self
        inspectionMapView.centerOn(Constants.LATITUDE, Constants.LONGITUDE, withDelta: Constants.DELTA)
        
        // TODO: WIP
        client.inspections { [weak self] result in
            switch result {
            case .success(let inspections):
                guard let self = self else {
                    return
                }
                
                var annotations: [MKAnnotation] = []
                for inspection in inspections {
                    guard let coordinate = inspection.coords.asCLLocationCoordinate() else {
                        continue
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = inspection.name
                    annotation.subtitle = inspection.address
                    annotation.coordinate = coordinate
                    annotations.append(annotation)
                }
                
                self.clusteringManager.add(annotations: annotations)
                self.clusteringManager.renderAnnotations(onMapView: self.inspectionMapView)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusteringManager.renderAnnotations(onMapView: inspectionMapView)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is ClusterAnnotation else {
            return nil
        }
        
        let id = ClusterAnnotationView.identifier
        
        var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        if clusterView == nil {
            clusterView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: id)
        } else {
            clusterView?.annotation = annotation
        }
        
        return clusterView
    }
}
