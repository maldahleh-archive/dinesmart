//
//  Collection+SafeLookup.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-19.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation

extension Collection {
    func safeGet(index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
