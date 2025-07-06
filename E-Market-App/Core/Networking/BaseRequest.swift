//
//  BaseRequest.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

struct BaseRequest: NetworkRequest {
    var endpoint: Endpoints?
    var method: HTTPMethod
    var headers: [HTTPHeader: String]?
    var parameters: Encodable?
    
    init(endpoint: Endpoints?,
         method: HTTPMethod = .get,
         headers: [HTTPHeader: String]? = [.contentType: ContentType.json.rawValue],
         parameters: Encodable? = nil) {
        
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
}
