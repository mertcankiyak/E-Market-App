//
//  FavoriteViewModel.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation

class FavoriteViewModel {
    
    let dataManager : CoreDataProtocol
    
    private(set) var favoriteItems: [FavoriteItemEntity] = []
    var onUpdate: (() -> Void)?
    var onActionCompleted: ((AlertType) -> Void)?
    
    init(dataManager : CoreDataProtocol = CoreDataManager.shared) {
        self.dataManager = dataManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesUpdate),
            name: .didUpdateFavorites,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadFavorites() {
        fetchFavoriteItems()
    }
    
    @objc private func handleFavoritesUpdate() {
        fetchFavoriteItems()
    }
    
    private func fetchFavoriteItems() {
        favoriteItems = dataManager.fetchAllFavoriteItems()
        DispatchQueue.main.async {
            self.onUpdate?()
        }
    }
    
    func addToCart(item: FavoriteItemEntity) {
        let product = item.toProductModelElement()
        dataManager.addToCart(product: product)
        onActionCompleted?(.itemAddedToCart)
    }
    
    func removeFromFavorites(item: FavoriteItemEntity) {
        guard let productId = item.productId else { return }
        dataManager.removeFromFavorites(productId: productId)
    }
}
