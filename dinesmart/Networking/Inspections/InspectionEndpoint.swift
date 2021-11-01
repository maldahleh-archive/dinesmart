import Foundation

enum Inspections {
    case all
}

extension Inspections: Endpoint {
    var base: String {
        return "https://infinite-stream-30246.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .all:
            return "/inspections"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .all:
            return nil
        }
    }
}
