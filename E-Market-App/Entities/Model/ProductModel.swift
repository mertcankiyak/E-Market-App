//
//  ProductModel.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import Foundation

struct ProductModelElement: Codable {
    let createdAt, name: String?
    let image: String?
    let price, description, model, brand: String?
    let id: String?
}

typealias ProductModel = [ProductModelElement]
