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
    let inspectionDictionary = InspectionDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inspectionMapView.delegate = self
        inspectionMapView.center()
        
        // TODO: WIP
        client.inspections { [weak self] result in
            switch result {
            case .success(let inspections):
                guard let self = self else {
                    return
                }
                
                var annotations: [MKAnnotation] = []
                for inspection in inspections {
                    guard let annotation = inspection.asMKAnnotation() else {
                        continue
                    }
                    
                    self.inspectionDictionary.insert(annotation.coordinate.latitude, annotation.coordinate.longitude, value: inspection)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
            let locations = inspectionDictionary.locationsAt(annotation.coordinate.latitude, annotation.coordinate.longitude) else {
            return
        }
        
        print(locations)
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
