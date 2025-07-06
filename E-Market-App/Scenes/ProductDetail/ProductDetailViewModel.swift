//
//  ProductDetailViewModel.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation

class ProductDetailViewModel {
    
    private let dataManager: CoreDataProtocol
    let product: ProductModelElement
    
    private(set) var isFavorite: Bool = false
   
    var onFavoriteStatusChanged: ((Bool) -> Void)?
    
    init(product: ProductModelElement,dataManager: CoreDataProtocol = CoreDataManager.shared) {
        self.product = product
        self.dataManager = dataManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesUpdate),
            name: .didUpdateFavorites,
            object: nil
        )
        
        checkInitialFavoriteStatus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func checkInitialFavoriteStatus() {
        guard let productId = product.id else { return }
        self.isFavorite = dataManager.isFavorite(productId: productId)
    }
    
    @objc private func handleFavoritesUpdate() {
        checkInitialFavoriteStatus()
        onFavoriteStatusChanged?(self.isFavorite)
    }
    
    
    func toggleFavorite() {
        dataManager.toggleFavorite(product: self.product)
    }
    
    func addToCart() {
        dataManager.addToCart(product: self.product)
    }
}
