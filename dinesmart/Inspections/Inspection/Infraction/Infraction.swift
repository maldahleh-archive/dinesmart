//
//  Infraction.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

struct Infraction: Hashable, Decodable {
    let infractionDetails: String
    let severity: String
    let action: String
}
