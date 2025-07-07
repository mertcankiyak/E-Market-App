//
//  MockNetworkManager.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation
import UIKit
@testable import E_Market_App 


class MockNetworkManager: NetworkManagingProtocol {
   
    var successDataToReturn: Any?
    
    var failureErrorToReturn: NetworkError?

    
    func performTask<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        if let error = failureErrorToReturn {
            completion(.failure(error))
            return
        }
        
        if let data = successDataToReturn {
            if let castedData = data as? T {
                completion(.success(castedData))
            } else {
                fatalError("MockNetworkManager'daki successDataToReturn, beklenen \(T.self) tipiyle uyumsuz.")
            }
            return
        }
        
        fatalError("MockNetworkManager için ne successDataToReturn ne de failureErrorToReturn ayarlanmadı.")
    }
    
    var mockImageResult: Result<Data, NetworkError>?
    
    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let result = mockImageResult else {
            fatalError("MockNetworkManager için mockImageResult ayarlanmadı.")
        }
        completion(result)
    }
}
