//
//  InspectedLocation.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit

struct InspectedLocation: Hashable, Decodable {
    let name: String
    let type: String
    let address: String
    let coords: Coordinate
    
    let inspections: [Inspection]
}

// MARK: - Mapping
extension InspectedLocation {
    func asAnnotation() -> MKPointAnnotation? {
        guard let coordinate = coords.asCLLocationCoordinate() else {
            return nil
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.subtitle = address
        annotation.coordinate = coordinate
        return annotation
    }
}
