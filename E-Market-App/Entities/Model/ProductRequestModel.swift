//
//  ProductRequestModel.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation

struct ProductRequestModel: Codable {
    var search: String? = nil
    let page, limit: Int?
}
