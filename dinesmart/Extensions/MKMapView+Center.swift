//
//  MKMapView+Center.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-15.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit

extension MKMapView {
    private struct Constants {
        static let LATITUDE = 43.8563
        static let LONGITUDE = -79.5085
        static let DELTA = 0.7
    }
    
    func center() {
        centerOn(Constants.LATITUDE, Constants.LONGITUDE, withDelta: Constants.DELTA)
    }
    
    private func centerOn(_ latitude: Double, _ longitude: Double, withDelta delta: Double) {
        setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)), animated: true)
    }
}
