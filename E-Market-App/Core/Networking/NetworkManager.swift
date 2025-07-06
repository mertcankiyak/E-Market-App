//
//  NetworkManager.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import Foundation
import UIKit

protocol NetworkManagingProtocol {
    func performTask<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class NetworkManager : NetworkManagingProtocol {
    static let shared = NetworkManager()
    private let urlSession = URLSession.shared
    
    private init() {}
    
    private func decodeData<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch let decodingError {
            throw NetworkError.decodingFailed(decodingError)
        }
    }
    
    private func processResponse(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 404:
            throw NetworkError.notFound
        case 401:
            throw NetworkError.invalidRefreshToken
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.unknownError(statusCode: httpResponse.statusCode)
        }
    }
}

extension NetworkManager {
    func performTask<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let urlRequest = try request.urlRequest()
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                do {
                    try self.processResponse(response: response)
                    let decodedObject = try self.decodeData(data: data, type: T.self)
                    completion(.success(decodedObject))
                }
                catch {
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                }
            }.resume()
        } catch {
            completion(.failure(error as? NetworkError ?? .invalidResponse))
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}




