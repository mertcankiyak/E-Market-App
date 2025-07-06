//
//  FavoriteItemEntitiy+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

extension FavoriteItemEntity {
    
    /// Bu FavoriteItemEntity nesnesini, API'den gelen modele (ProductModelElement) dönüştürür.
    /// Bu, CoreDataManager gibi API modelini bekleyen fonksiyonlarla uyumluluk sağlar.
    /// - Returns: Doldurulmuş bir ProductModelElement nesnesi.
    func toProductModelElement() -> ProductModelElement {
        // ProductModelElement'in tüm alanları opsiyonel (?) olduğu için bu dönüşüm çok kolay.
        return ProductModelElement(
            createdAt: nil, // Favori objesinde bu bilgi yok, nil geçebiliriz.
            name: self.name,
            image: self.imageURL,
            price: self.price,
            description: nil, // Favori objesinde bu bilgi yok.
            model: nil,       // Favori objesinde bu bilgi yok.
            brand: nil,       // Favori objesinde bu bilgi yok.
      id: self.productId
        )
    }
}
