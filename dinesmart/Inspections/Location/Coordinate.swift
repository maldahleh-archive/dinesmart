//
//  Coordinate.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit

struct Coordinate: Hashable, Decodable {
    let lat: String
    let lon: String
    
    func asCLLocationCoordinate() -> CLLocationCoordinate2D? {
        guard let lat = Double(lat), let long = Double(lon) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
