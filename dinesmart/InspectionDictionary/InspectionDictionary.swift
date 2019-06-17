//
//  InspectionDictionary.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-16.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation

class InspectionDictionary {
    var dictionary: [Double: [Double: [InspectedLocation]]] = [:]
    
    func insert(_ lat: Double, _ long: Double, value: InspectedLocation) {
        var localData: [InspectedLocation] = []
        if let loadedData = dictionary[lat]?[long] {
            localData = loadedData
        }
        
        localData.append(value)
        if dictionary[lat] == nil {
            dictionary[lat] = [:]
        }
        
        dictionary[lat]![long] = localData
    }
    
    func locationsAt(_ lat: Double, _ long: Double) -> [InspectedLocation]? {
        for (key, value) in dictionary {
            if (abs(lat - key) > 0.001) {
                continue
            }
            
            for (nestedKey, nestedValue) in value {
                if (abs(long - nestedKey) > 0.001) {
                    continue
                }
                
                return nestedValue
            }
        }
        
        return nil
    }
}
