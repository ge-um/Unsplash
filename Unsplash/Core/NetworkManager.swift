//
//  NetworkManager.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Alamofire
import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case unknown = 503
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            "BAD REQUEST"
        case .unauthorized:
            "UNAURHORIZED"
        case .forbidden:
            "FORBIDDEN"
        case .notFound:
            "NOT FOUND"
        case .serverError:
            "SERVER ERROR"
        case .unknown:
            "UNKNOWN ERROR"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: APIRouter, type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let endPoint = api.endPoint else {
            #if DEBUG
            print("Invalid URL")
            #endif
            return
        }
        
        AF.request(endPoint, parameters: api.parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(.success(result))
                case .failure:
                    let statusCode = response.response?.statusCode ?? 500
                    let errorType = NetworkError(rawValue: statusCode)
                    
                    completionHandler(.failure((errorType ?? .unknown)))
                }
            }
    }
    
    #if DEBUG
    func callRequest(api: APIRouter) {
        guard let endPoint = api.endPoint else {
            print("Invalid URL")
            return
        }
        
        AF.request(endPoint, parameters: api.parameters)
            .responseString { response in
                print(response)
            }
        }
    #endif
}
