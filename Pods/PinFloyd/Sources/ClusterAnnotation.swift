import Foundation
import MapKit

public class ClusterAnnotation: NSObject, MKAnnotation {

    public let coordinate: CLLocationCoordinate2D
    public let heldAnnotations: [MKAnnotation]
    public let annotationsCount: Int
    
    public var title: String?
    public var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, heldAnnotations: [MKAnnotation]) {
        self.coordinate = coordinate
        self.heldAnnotations = heldAnnotations
        self.annotationsCount = heldAnnotations.count
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? ClusterAnnotation {
            return annotationsCount == rhs.annotationsCount && coordinate == rhs.coordinate
        }
        
        return super.isEqual(object)
    }

    public override var hash: Int {
        return annotationsCount.hashValue ^ coordinate.latitude.hashValue ^ coordinate.longitude.hashValue
    }
}
