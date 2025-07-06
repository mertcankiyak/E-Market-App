//
//  CoreDataManager.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    func fetchAllFavoriteProductIds() -> Set<String>
    func addToCart(product: ProductModelElement)
    func toggleFavorite(product: ProductModelElement)
    func isFavorite(productId: String) -> Bool
    func fetchAllCartItems() -> [CartItemEntity]
    func incrementQuantity(for item: CartItemEntity)
    func decrementQuantity(for item: CartItemEntity)
    func fetchAllFavoriteItems() -> [FavoriteItemEntity]
    func removeFromFavorites(productId: String)
}



class CoreDataManager : CoreDataProtocol {
    
    static let shared = CoreDataManager()
    private let containerName = "E_Market_App"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved CoreData error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    private init() {}
    
    
    private func saveContext(for type: UpdateType) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            DispatchQueue.main.async {
                switch type {
                case .cart:
                    NotificationCenter.default.post(name: .didUpdateCart, object: nil)
                case .favorite:
                    NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
                }
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved CoreData saving error \(nserror), \(nserror.userInfo)")
        }
    }
    
    enum UpdateType {
        case cart
        case favorite
    }
    
    
    func addToCart(product: ProductModelElement) {
        guard let productId = product.id else {
            print("Cannot add product to cart: Product ID is nil.")
            return
        }
        
        if let existingCartItem = fetchCartItem(with: productId) {
            existingCartItem.quantity += 1
        } else {
            let newItem = CartItemEntity(context: context)
            newItem.productId = productId
            newItem.name = product.name
            newItem.price = product.price
            newItem.imageURL = product.image
            newItem.quantity = 1
        }
        
        saveContext(for: .cart)
    }
    
    func incrementQuantity(for cartItem: CartItemEntity) {
        cartItem.quantity += 1
        saveContext(for: .cart)
    }
    
    
    func decrementQuantity(for cartItem: CartItemEntity) {
        if cartItem.quantity > 1 {
            cartItem.quantity -= 1
        } else {
            context.delete(cartItem)
        }
        saveContext(for: .cart)
    }
    
    func removeFromCart(cartItem: CartItemEntity) {
        context.delete(cartItem)
        saveContext(for: .cart)
    }
    
    func clearCart() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext(for: .cart)
        } catch let error as NSError {
            print("Error clearing cart: \(error), \(error.userInfo)")
        }
    }
    
    
    
    func fetchAllCartItems() -> [CartItemEntity] {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch cart items: \(error)")
            return []
        }
    }
    
    
    func fetchCartItem(with productId: String) -> CartItemEntity? {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %@", productId)
        request.fetchLimit = 1 // Sadece bir tane bulmamız yeterli.
        
        do {
            let items = try context.fetch(request)
            return items.first
        } catch {
            print("Failed to fetch cart item with id \(productId): \(error)")
            return nil
        }
    }
    
    func fetchFavoriteItem(with productId: String) -> FavoriteItemEntity? {
        let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %@", productId)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch favorite item with id \(productId): \(error)")
            return nil
        }
    }
    
    func fetchAllFavoriteProductIds() -> Set<String> {
        let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        do {
            let items = try context.fetch(request)
            let ids = items.compactMap { $0.productId }
            return Set(ids)
        } catch {
            return []
        }
    }
    
    
    func isFavorite(productId: String) -> Bool {
        return fetchFavoriteItem(with: productId) != nil
    }
    
    func toggleFavorite(product: ProductModelElement) {
        guard let productId = product.id else { return }
        
        if let favoriteItem = fetchFavoriteItem(with: productId) {
            context.delete(favoriteItem)
        } else {
            let newItem = FavoriteItemEntity(context: context)
            newItem.productId = productId
            newItem.name = product.name
            newItem.price = product.price
            newItem.imageURL = product.image
        }
        
        saveContext(for: .favorite)
    }
    
    func removeFromFavorites(productId: String) {
        if let favoriteItem = fetchFavoriteItem(with: productId) {
            context.delete(favoriteItem)
            saveContext(for: .favorite)
        }
    }
    
    func fetchAllFavoriteItems() -> [FavoriteItemEntity] {
        let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch favorite items: \(error)")
            return []
        }
    }
    
    func getTotalItemCountInCart() -> Int {
        let items = fetchAllCartItems()
        let totalCount = items.reduce(0) { $0 + Int($1.quantity) }
        return totalCount
    }
}
