//
//  ViewController.swift
//  DineSmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-04.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inspectionMapView: MKMapView!
    
    let client = InspectionClient()
    
    private struct Constants {
        static let LATITUDE = 43.8563
        static let LONGITUDE = -79.5085
        static let DELTA = 0.7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inspectionMapView.centerOn(Constants.LATITUDE, Constants.LONGITUDE, withDelta: Constants.DELTA)
        
        // TODO: WIP
        client.inspections { [weak self] result in
            switch result {
            case .success(let inspections):
                guard let self = self else {
                    return
                }
                
                for inspection in inspections {
                    guard let coordinate = inspection.coords.asCLLocationCoordinate() else {
                        continue
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = inspection.name
                    annotation.subtitle = inspection.address
                    annotation.coordinate = coordinate
                    self.inspectionMapView.addAnnotation(annotation)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
