//
//  HomeViewModelTest.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//


import XCTest
@testable import E_Market_App

final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var mockDataManager: MockDataManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockDataManager = MockDataManager()
        viewModel = HomeViewModel(networkManager: mockNetworkManager, dataManager: mockDataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockDataManager = nil
        super.tearDown()
    }
    
    func testFetchProductsFromAPI() {
        let mockProducts = [
            ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1"),
            ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1"),
            ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1"),
            ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1"),
            
        ]
        mockNetworkManager.successDataToReturn = mockProducts
        let expectation = self.expectation(description: "Fetch success")
        viewModel.onStateChange = { state in
            if case .success = state {
                expectation.fulfill()
            }
        }
        viewModel.fetchInitialData()
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(viewModel.displayedProducts.count, 4, "Başarılı fetch sonrası ürün sayısı 4 olmalı.")
        XCTAssertEqual(viewModel.displayedProducts.first?.name, "iPhone", "İlk ürünün adı doğru olmalı.")
    }
    
    func testFetchProductsFromAPIEmptyData() {
        let emptyProducts: ProductModel = []
        mockNetworkManager.successDataToReturn = emptyProducts
        var finalState: ViewState?
        let expectation = self.expectation(description: "Fetch empty")
        viewModel.onStateChange = { state in
            if case .empty = state {
                finalState = state
                expectation.fulfill()
            }
        }
        viewModel.fetchInitialData()
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(finalState, .empty)
    }
    
    func testFetchProductsFromAPIErrorState() {
        let expectedError = NetworkError.internalServerError
        mockNetworkManager.failureErrorToReturn = expectedError
        var finalState: ViewState?
        let expectation = self.expectation(description: "Fetch failure")
        
        viewModel.onStateChange = { state in
            if case .error = state {
                finalState = state
                expectation.fulfill()
            }
        }
        viewModel.fetchInitialData()
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(finalState, .error(expectedError.localizedDescription))
    }
    
    func testToggleFavorite() {
        let productToFavorite = ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1")
        XCTAssertFalse(mockDataManager.isFavorite(productId: productToFavorite.id!), "Test başlangıcında ürün favori olmamalı.")
        let alertExpectation = self.expectation(description: "Alert for adding to favorites should be triggered")
        var capturedAlertType: AlertType?
        viewModel.onActionCompleted = { alertType in
            capturedAlertType = alertType
            alertExpectation.fulfill()
        }
        viewModel.toggleFavorite(product: productToFavorite)
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(mockDataManager.toggleFavoriteCalled, "DataManager'ın toggleFavorite metodu çağrılmalıydı.")
        XCTAssertEqual(capturedAlertType, .itemAddedToFavorites, "Ürün favoriye eklenirken .itemAddedToFavorites uyarısı tetiklenmeli.")
    }
    
    func testAddToCart() {
        let productToAdd = ProductModelElement(createdAt: "2023-07-17T07:21:02.529Z",name: "iPhone",image: "https://loremflickr.com/640/480/food", price: "123" ,description: "apple description",model: "iphone" ,brand: "Apple", id: "1")
        XCTAssertFalse(mockDataManager.addToCartCalled, "Başlangıçta 'addToCartCalled' bayrağı false olmalı.")
        let alertExpectation = self.expectation(description: "Alert for adding to cart should be triggered")
        var capturedAlertType: AlertType?
        
        viewModel.onActionCompleted = { alertType in
            capturedAlertType = alertType
            alertExpectation.fulfill()
        }
        viewModel.addToCart(product: productToAdd)
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(mockDataManager.addToCartCalled, "DataManager'ın addToCart metodu çağrılmalıydı.")
        XCTAssertEqual(capturedAlertType, .itemAddedToCart, "Sepete ekleme işlemi için .itemAddedToCart uyarısı tetiklenmeli.")
    }
    
}
