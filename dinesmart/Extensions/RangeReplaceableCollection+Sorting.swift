//
//  RangeReplaceableCollection+Sorting.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-16.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

extension RangeReplaceableCollection where Element: Hashable {
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}
