//
//  NetworkRequest.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import Foundation

protocol NetworkRequest {
    var endpoint: Endpoints? { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader: String]? { get set }
    var parameters: Encodable? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}
