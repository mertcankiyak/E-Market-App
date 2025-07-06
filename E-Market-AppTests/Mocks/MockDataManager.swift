//
//  MockDataManager.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//


@testable import E_Market_App
import Foundation

class MockDataManager: CoreDataProtocol {

    var favoriteProductIds: Set<String> = []
    var cartItemsToReturn: [CartItemEntity] = []
        var incrementQuantityCalled = false
        var decrementQuantityCalled = false
    
    // Hangi fonksiyonların çağrıldığını kontrol etmek için
    var addToCartCalled = false
    var toggleFavoriteCalled = false
    
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
