//
//  InspectedLocation.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation

struct InspectedLocation: Decodable {
    let id: String
    let name: String
    let type: String
    let address: String
    let minInspections: String
    
    let inspections: [Inspection]
}
