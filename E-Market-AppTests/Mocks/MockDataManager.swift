//
//  MockDataManager.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//


@testable import E_Market_App
import Foundation

class MockDataManager: CoreDataProtocol {
    
    
    
    
    var favoriteItemsToReturn: [FavoriteItemEntity] = []
    
    var removeFromFavoritesCalled = false
    
    var removedProductId: String?
    
    var favoriteProductIds: Set<String> = []
    var fetchAllFavoriteItemsList : [FavoriteItemEntity] = []
    var cartItemsToReturn: [CartItemEntity] = []
    var incrementQuantityCalled = false
    var decrementQuantityCalled = false
    
    var addToCartCalled = false
    var toggleFavoriteCalled = false
    var removeFromFavorites = true
    
    func fetchAllFavoriteItems() -> [E_Market_App.FavoriteItemEntity] {
        return fetchAllFavoriteItemsList
    }
    
    func removeFromFavorites(productId: String) {
        self.removeFromFavoritesCalled = true
        
        self.removedProductId = productId
        
        
        if let index = favoriteItemsToReturn.firstIndex(where: { $0.productId == productId }) {
            favoriteItemsToReturn.remove(at: index)
        }
    }
    
    
    func fetchAllFavoriteProductIds() -> Set<String> {
        return favoriteProductIds
    }
    
    func addToCart(product: ProductModelElement) {
        addToCartCalled = true
    }
    
    func toggleFavorite(product: ProductModelElement) {
        toggleFavoriteCalled = true
    }
    
    func isFavorite(productId: String) -> Bool {
        return favoriteProductIds.contains(productId)
    }
    
    func fetchAllCartItems() -> [CartItemEntity] {
        return cartItemsToReturn
    }
    
    func incrementQuantity(for item: CartItemEntity) {
        incrementQuantityCalled = true
    }
    
    func decrementQuantity(for item: CartItemEntity) {
        decrementQuantityCalled = true
    }
}
