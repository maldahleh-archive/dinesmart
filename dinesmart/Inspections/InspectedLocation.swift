//
//  InspectedLocation.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import MapKit
import Realm
import RealmSwift

@objcMembers class InspectedLocation: Object, Decodable {
    dynamic var name = ""
    dynamic var type = ""
    dynamic var address = ""
    dynamic var coords: Coordinate? = nil
    
    let inspections = List<Inspection>()
    
    private enum CodingKeys: String, CodingKey {
        case name, type, address, coords, inspections
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.coords = try container.decode(Coordinate.self, forKey: .coords)
        
        let inspectionList = try container.decode([Inspection].self, forKey: .inspections)
        inspections.append(objectsIn: inspectionList)
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

// MARK: - Mapping
extension InspectedLocation {
    func asAnnotation() -> MKPointAnnotation? {
        guard let coords = coords,
            let coordinate = coords.asCLLocationCoordinate() else {
                return nil
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.subtitle = address
        annotation.coordinate = coordinate
        return annotation
    }
}
