//
//  ProductDetailTest.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

// in YourProjectTests/ProductDetailViewModelTests.swift

import XCTest
@testable import E_Market_App

final class ProductDetailViewModelTests: XCTestCase {

    var mockDataManager: MockDataManager!
    var product: ProductModelElement!

    override func setUp() {
        super.setUp()
        mockDataManager = MockDataManager()
        product = ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1")
    }

    override func tearDown() {
        mockDataManager = nil
        product = nil
        super.tearDown()
    }

    func testProductFavoriteToFalse() {
        let viewModel = ProductDetailViewModel(product: product, dataManager: mockDataManager)
        
        XCTAssertFalse(viewModel.isFavorite, "Ürün favori değilken isFavorite false olmalı.")
    }
    
    func testProductFavoriteToTrue() {
       
        mockDataManager.favoriteProductIds = [product.id!]
        let viewModel = ProductDetailViewModel(product: product, dataManager: mockDataManager)
        
        XCTAssertTrue(viewModel.isFavorite, "Ürün favori iken isFavorite true olmalı.")
    }
    
   
    func testToggleCartManager() {
        let viewModel = ProductDetailViewModel(product: product, dataManager: mockDataManager)
        viewModel.toggleFavorite()
        XCTAssertTrue(mockDataManager.toggleFavoriteCalled, "toggleFavorite, DataManager'daki metodu çağırmalı.")
    }
    
    func testCallDataManager() {
        let viewModel = ProductDetailViewModel(product: product, dataManager: mockDataManager)
        viewModel.addToCart()
        XCTAssertTrue(mockDataManager.addToCartCalled, "addToCart, DataManager'daki metodu çağırmalı.")
    }
    
    func testFavoriUpdateStatus() {
        let viewModel = ProductDetailViewModel(product: product, dataManager: mockDataManager)
        XCTAssertFalse(viewModel.isFavorite)
        let statusChangeExpectation = self.expectation(description: "onFavoriteStatusChanged should be called")
        
        var newFavoriteStatus: Bool?
        viewModel.onFavoriteStatusChanged = { isFavorite in
            newFavoriteStatus = isFavorite
            statusChangeExpectation.fulfill()
        }
        mockDataManager.favoriteProductIds = [product.id!]
        
        NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(viewModel.isFavorite, "Bildirim sonrası isFavorite true olmalı.")
        XCTAssertEqual(newFavoriteStatus, true, "Callback, doğru favori durumunu dönmeli.")
    }
}
