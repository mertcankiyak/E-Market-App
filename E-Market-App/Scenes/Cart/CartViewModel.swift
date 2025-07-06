//
//  CartViewModel.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import Foundation

class CartViewModel {
    
    private let dataManager: CoreDataProtocol
    private(set) var cartItems: [CartItemEntity] = []
    
    var onUpdate: (() -> Void)?
    
    var totalPrice: Double {
        return cartItems.reduce(0) { total, item in
            let price = Double(item.price ?? "0") ?? 0.0
            return total + (price * Double(item.quantity))
        }
    }
    
    var totalPriceString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: totalPrice)) ?? "0.00 ₺"
    }
    
    // MARK: - Initializer
    init(dataManager: CoreDataProtocol = CoreDataManager.shared) {
        self.dataManager = dataManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCartUpdate),
            name: .didUpdateCart,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCartData() {
        fetchCartItems()
    }
        
    @objc private func fetchCartItems() {
        cartItems = dataManager.fetchAllCartItems()
        DispatchQueue.main.async {
            self.onUpdate?()
        }
    }
    
    @objc private func handleCartUpdate() {
        print("carc viewmodel update...")
        fetchCartItems()
    }
    
    func incrementQuantity(for item: CartItemEntity) {
        dataManager.incrementQuantity(for: item)
      
    }
    
    func decrementQuantity(for item: CartItemEntity) {
        dataManager.decrementQuantity(for: item)
    }
}
