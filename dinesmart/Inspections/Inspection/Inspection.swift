//
//  Inspection.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

struct Inspection: Hashable, Decodable {
    let date: String
    let status: String
    
    let infractions: [Infraction]
}
