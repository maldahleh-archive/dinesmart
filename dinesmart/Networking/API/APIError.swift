//
//  APIError.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

enum APIError: Error {
    case requestFailed
    case invalidData
    case responseUnsuccessful
    case jsonConversionFailure
}
