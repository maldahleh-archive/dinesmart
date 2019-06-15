//
//  MKMapView+Center.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-15.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit

extension MKMapView {
    func centerOn(_ latitude: Double, _ longitude: Double, withDelta delta: Double) {
        setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)), animated: true)
    }
}
