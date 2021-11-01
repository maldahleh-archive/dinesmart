import MapKit
import RealmSwift

class Coordinate: Object, Decodable {
    @Persisted var lat = ""
    @Persisted var lon = ""
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
