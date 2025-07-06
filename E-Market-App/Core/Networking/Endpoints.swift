//
//  Endpoints.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import Foundation

enum Endpoints{
    case getProducts
}

extension Endpoints {
    var getRawValue : String {
        switch self {
        case .getProducts:
            return "/products"
        }
    }
}
