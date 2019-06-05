//
//  InspectionEndpoint.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation

enum Inspections {
    case all
}

extension Inspections: Endpoint {
    var base: String {
        return "https://shrouded-meadow-40073.herokuapp.com"
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
