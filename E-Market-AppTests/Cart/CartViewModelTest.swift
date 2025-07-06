//
//  CartViewModelTest.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import XCTest
import CoreData
@testable import E_Market_App

final class CartViewModelTests: XCTestCase {

    var viewModel: CartViewModel!
    var mockDataManager: MockDataManager!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        mockContext = TestCoreDataStack().managedObjectContext
        mockDataManager = MockDataManager()
        viewModel = CartViewModel(dataManager: mockDataManager)
    }

    override func tearDown() {
        viewModel = nil
        mockDataManager = nil
        mockContext = nil
        super.tearDown()
    }
    
    private func createMockCartItem(name: String, price: String, quantity: Int16) -> CartItemEntity {
        let item = CartItemEntity(context: mockContext)
        item.name = name
        item.price = price
        item.quantity = quantity
        return item
    }

    // MARK: - Test Scenario

    func testLoadDataAndCalculateTotalPrice() {
        let item1 = createMockCartItem(name: "Product A", price: "100", quantity: 2)
        let item2 = createMockCartItem(name: "Product B", price: "50.5", quantity: 1)
        mockDataManager.cartItemsToReturn = [item1, item2]
        
        let updateExpectation = self.expectation(description: "onUpdate should be called")
        viewModel.onUpdate = {
            updateExpectation.fulfill()
        }
        viewModel.loadCartData()
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(viewModel.cartItems.count, 2, "Sepette 2 ürün olmalı.")
        XCTAssertEqual(viewModel.totalPrice, 250.5, "Toplam fiyat doğru hesaplanmalı.")
        XCTAssertTrue(viewModel.totalPriceString.contains("250,50"), "Formatlanmış fiyat string'i doğru olmalı.")
    }
    
    func testEmptyCart() {
        mockDataManager.cartItemsToReturn = []
        viewModel.loadCartData()
        XCTAssertEqual(viewModel.cartItems.count, 0)
        XCTAssertEqual(viewModel.totalPrice, 0.0)
    }
    
    func testIncrementQuantity() {
        let item = createMockCartItem(name: "Test", price: "10", quantity: 1)
        viewModel.incrementQuantity(for: item)
        XCTAssertTrue(mockDataManager.incrementQuantityCalled, "incrementQuantity metodu DataManager'ı tetiklemeli.")
    }
    
    func testDecrementQuantity() {
        let item = createMockCartItem(name: "Test", price: "10", quantity: 2)
        viewModel.decrementQuantity(for: item)
        XCTAssertTrue(mockDataManager.decrementQuantityCalled, "decrementQuantity metodu DataManager'ı tetiklemeli.")
    }
    
    func testHandleCartUpdateNotification() {
        mockDataManager.cartItemsToReturn = []
        let setupExpectation = self.expectation(description: "Initial setup load finished")
        viewModel.onUpdate = {
            setupExpectation.fulfill()
        }
        viewModel.loadCartData()
        wait(for: [setupExpectation], timeout: 1.0)
        XCTAssertEqual(viewModel.cartItems.count, 0, "Kurulum sonrası sepet boş olmalı.")
        let newItem = createMockCartItem(name: "New Item", price: "99", quantity: 1)
        mockDataManager.cartItemsToReturn = [newItem]
        let notificationExpectation = self.expectation(description: "onUpdate called after notification")
        viewModel.onUpdate = {
            notificationExpectation.fulfill()
        }
        NotificationCenter.default.post(name: .didUpdateCart, object: nil)
        wait(for: [notificationExpectation], timeout: 1.0)
        XCTAssertEqual(viewModel.cartItems.count, 1, "Bildirim sonrası sepet güncellenmeli.")
        XCTAssertEqual(viewModel.cartItems.first?.name, "New Item")
    }
}


// MARK: - Test Core Data Helper
// Varsayılan coredata yapısına müdahale etmek istemedim, hafıza bir coredata oluşturdum.
class TestCoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "E_Market_App")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
