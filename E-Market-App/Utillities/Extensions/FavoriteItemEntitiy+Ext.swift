//
//  FavoriteItemEntitiy+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

extension FavoriteItemEntity {
    

    func toProductModelElement() -> ProductModelElement {
        return ProductModelElement(
            createdAt: nil, 
            name: self.name,
            image: self.imageURL,
            price: self.price,
            description: nil,
            model: nil,
            brand: nil,
      id: self.productId
        )
    }
}
