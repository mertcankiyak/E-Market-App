//
//  MockNetworkManager.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation
import UIKit // UIImage'dan Data oluşturmak için gerekebilir
@testable import E_Market_App // Projenizin gerçek adını buraya yazın

// in YourProjectTests/Mocks/MockNetworkManager.swift

import Foundation
@testable import E_Market_App // Projenizin adı

// Bu mock sınıfı, önceki tüm karmaşıklıklardan arındırılmıştır.
class MockNetworkManager: NetworkManagingProtocol {
    
    // MARK: - Properties for Controlling Test Behavior
    
    // Başarılı bir sonuç döndürmek için bu değişkene veri ata.
    // Tipi 'Any' olduğu için her türlü Decodable modeli atayabiliriz.
    var successDataToReturn: Any?
    
    // Hatalı bir sonuç döndürmek için bu değişkene bir NetworkError ata.
    var failureErrorToReturn: NetworkError?

    // MARK: - Conformance to NetworkManagingProtocol
    
    func performTask<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        // 1. Hata senaryosunu kontrol et
        if let error = failureErrorToReturn {
            completion(.failure(error))
            return
        }
        
        // 2. Başarı senaryosunu kontrol et
        if let data = successDataToReturn {
            // Gelen 'Any' tipindeki veriyi, 'ViewModel'in beklediği 'T' tipine cast et.
            if let castedData = data as? T {
                completion(.success(castedData))
            } else {
                // Eğer testte yanlış tipte veri set ettiysek, bunu anlamak için çökert.
                fatalError("MockNetworkManager'daki successDataToReturn, beklenen \(T.self) tipiyle uyumsuz.")
            }
            return
        }
        
        // 3. Testi yazan kişi hiçbir şey set etmediyse, bunu anlamak için çökert.
        fatalError("MockNetworkManager için ne successDataToReturn ne de failureErrorToReturn ayarlanmadı.")
    }
    
    // downloadImage için de aynı basit yapıyı kuralım.
    var mockImageResult: Result<Data, NetworkError>?
    
    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let result = mockImageResult else {
            fatalError("MockNetworkManager için mockImageResult ayarlanmadı.")
        }
        completion(result)
    }
}
