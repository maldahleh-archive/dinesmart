import MapKit
import RealmSwift

class InspectedLocation: Object, Decodable {
    @Persisted var name = ""
    @Persisted var type = ""
    @Persisted var address = ""
    @Persisted var coords: Coordinate?
    @Persisted var inspections: List<Inspection>
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
