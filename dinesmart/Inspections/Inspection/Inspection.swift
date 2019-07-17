//
//  Inspection.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

struct Inspection: Hashable, Decodable {
    let id: String
    let inspectionDate: String
    let status: String
    let inspectionType: String
    
    let infractions: [Infraction]
}
