//
//  Result.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
