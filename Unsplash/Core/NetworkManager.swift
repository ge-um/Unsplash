//
//  NetworkManager.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case endPoint
    case AFError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: APIRouter, type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let endPoint = api.endPoint else {
            completionHandler(.failure(.endPoint))
            return
        }
        
        // TODO: - 에러 핸들링
        AF.request(endPoint, parameters: api.parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(.success(result))
                case .failure:
                    completionHandler(.failure(.AFError))
                }
            }
        }
}
