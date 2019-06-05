//
//  APIClient.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-05.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation

protocol APIClient: class {
    var session: URLSession { get }
    var jsonDecoder: JSONDecoder { get }
    
    func fetchWith<T: Decodable>(_ request: URLRequest, decode: T.Type, completion: @escaping FetchTaskCompletionHandler<T>)
}

extension APIClient {
    typealias FetchTaskCompletionHandler<T: Decodable> = (Result<T, APIError>) -> Void
    typealias JSONTaskCompletionHandler = (Data?, APIError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode != 200 {
                completion(nil, .responseUnsuccessful)
                return
            }
            
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            
            completion(data, nil)
        }
        
        return task
    }
    
    func fetchWith<T: Decodable>(_ request: URLRequest, decode: T.Type, completion: @escaping FetchTaskCompletionHandler<T>) {
        jsonTask(with: request) { [weak self] json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.failure(error ?? .invalidData))
                    return
                }
                
                guard let self = self else {
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                
                do {
                    let parsed = try self.jsonDecoder.decode(decode, from: json)
                    completion(.success(parsed))
                } catch {
                    completion(.failure(.jsonConversionFailure))
                }
            }
            }.resume()
    }
}
