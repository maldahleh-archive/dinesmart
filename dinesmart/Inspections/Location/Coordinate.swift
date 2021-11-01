import MapKit
import Realm
import RealmSwift

@objcMembers class Coordinate: Object, Decodable {
    dynamic var lat = ""
    dynamic var lon = ""
    
    private enum CodingKeys: String, CodingKey {
        case lat, lon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.lat = try container.decode(String.self, forKey: .lat)
        self.lon = try container.decode(String.self, forKey: .lon)
        
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
extension Coordinate {
    func asCLLocationCoordinate() -> CLLocationCoordinate2D? {
        guard let lat = Double(lat), let long = Double(lon) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
