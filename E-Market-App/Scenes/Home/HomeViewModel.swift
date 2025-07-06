//
//  HomeViewModel.swift
//  E-Market-App
//
//  Created by Mert on 5.07.2025.
//

import Foundation

enum ViewState : Equatable{
    case loading
    case success
    case error(String)
    case empty
}

class HomeViewModel {
    
    var loadedProducts: [ProductModelElement] = []
    var activeFilters = FilterData()
    var displayedProducts: [ProductModelElement] = []
    var currentPage = 1
    let limit = 4
    var isLoadingMore = false
    var hasMoreProducts = true
    var favoriteProductIds: Set<String> = []
    var currentSearchQuery: String? = nil
    
    var onStateChange: ((ViewState) -> Void)?
    var onFavoritesUpdated: (() -> Void)?
    var onActionCompleted: ((AlertType) -> Void)?
    
    let networkManager: NetworkManagingProtocol
    let dataManager: CoreDataProtocol
    
    init(networkManager: NetworkManagingProtocol = NetworkManager.shared, dataManager: CoreDataProtocol = CoreDataManager.shared) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesUpdate),
            name: .didUpdateFavorites,
            object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleFilterUpdate),
                name: .didApplyFilters,
                object: nil
            )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func fetchInitialData() {
        fetchFavoriteIds()
        loadProductsFromAPI(isInitialLoad: true)
    }
    
    func loadProductsFromAPI(isInitialLoad: Bool = false) {
        guard !isLoadingMore, hasMoreProducts else { return }
        
        isLoadingMore = true
        if isInitialLoad {
            currentPage = 1
            loadedProducts.removeAll()
            onStateChange?(.loading)
        }
        
        var productRequestModel : ProductRequestModel? = nil
        
        if let query = currentSearchQuery, !query.isEmpty {
            productRequestModel = ProductRequestModel( search: query,page: currentPage, limit: limit)
        } else {
            productRequestModel = ProductRequestModel(page: currentPage, limit: limit)
        }
        
        let request = BaseRequest(endpoint: .getProducts, parameters: productRequestModel)
        
        networkManager.performTask(request, decodeTo: ProductModel.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoadingMore = false
                switch result {
                case .success(let newProducts):
                    if newProducts.count < self.limit { self.hasMoreProducts = false }
                    
                    self.loadedProducts.append(contentsOf: newProducts)
                    self.currentPage += 1
                    
                    self.applyClientSideFilters()
                    
                case .failure(let error):
                    if isInitialLoad { self.onStateChange?(.error(error.localizedDescription)) }
                }
            }
        }
    }
    
    func searchOnLoadedProducts(with query: String) {
        if query.isEmpty {
            applyClientSideFilters()
            return
        }
        
        let lowercasedQuery = query.lowercased()
        let searchResult = loadedProducts.filter {
            $0.name?.lowercased().contains(lowercasedQuery) ?? false
        }
        
        self.displayedProducts = searchResult
        onStateChange?(.success)
    }
    
    func updateAndApplyFilters(filters: FilterData) {
        self.activeFilters = filters
        applyClientSideFilters()
    }
    
    func applyFilters(filters: FilterData) {
        self.activeFilters = filters
        self.currentSearchQuery = nil
        self.hasMoreProducts = true
        self.onStateChange?(.loading)
        self.loadProductsFromAPI(isInitialLoad: true)
    }
    
    private func applyClientSideFilters() {
        var processingList = loadedProducts
        
        if !activeFilters.selectedBrands.isEmpty {
            processingList = processingList.filter { product in
                guard let brand = product.brand else { return false }
                return activeFilters.selectedBrands.contains(brand)
            }
        }
        
        if !activeFilters.selectedModels.isEmpty {
            processingList = processingList.filter { product in
                guard let model = product.model else { return false }
                return activeFilters.selectedModels.contains(model)
            }
        }
        
        if let sortBy = activeFilters.sortBy {
            processingList.sort { p1, p2 in
                let price1 = Double(p1.price ?? "0") ?? 0.0
                let price2 = Double(p2.price ?? "0") ?? 0.0
                let date1 = p1.createdAt ?? ""
                let date2 = p2.createdAt ?? ""
                
                switch sortBy {
                case .priceLowToHigh: return price1 < price2
                case .priceHighToLow: return price1 > price2
                case .newToOld: return date1 > date2
                case .oldToNew: return date1 < date2
                }
            }
        }
        
        self.displayedProducts = processingList
        onStateChange?(self.displayedProducts.isEmpty ? .empty : .success)
    }
    
    func getAvailableFilterOptions() -> (brands: [String], models: [String]) {
        let brands = Set(loadedProducts.compactMap { $0.brand })
        let models = Set(loadedProducts.compactMap { $0.model })
        return (Array(brands).sorted(), Array(models).sorted())
    }
    
    private func fetchFavoriteIds() {
        self.favoriteProductIds = self.dataManager.fetchAllFavoriteProductIds()
    }
    
    func addToCart(product: ProductModelElement) {
        self.dataManager.addToCart(product: product)
        onActionCompleted?(.itemAddedToCart)
    }
    
    func toggleFavorite(product: ProductModelElement) {
        let isCurrentlyFavorite = isProductFavorite(productId: product.id)
        self.dataManager.toggleFavorite(product: product)
        let alertType: AlertType = isCurrentlyFavorite ? .itemRemovedFromFavorites : .itemAddedToFavorites
        onActionCompleted?(alertType)
    }
    
    func searchProducts(with query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery == currentSearchQuery { return }
        self.currentSearchQuery = trimmedQuery.isEmpty ? nil : trimmedQuery
        self.hasMoreProducts = true
        self.onStateChange?(.loading)
        self.loadProductsFromAPI(isInitialLoad: true)
    }
    
    
    func isProductFavorite(productId: String?) -> Bool {
        guard let productId = productId else { return false }
        return favoriteProductIds.contains(productId)
    }
    
    @objc private func handleFavoritesUpdate() {
        
        fetchFavoriteIds()
        onFavoritesUpdated?()
    }
    
    @objc private func handleFilterUpdate(_ notification: Notification) {
        if let filters = notification.object as? FilterData {
            self.applyFilters(filters: filters) 
        }
    }
    
    func getActiveFiltersDescription() -> String {
        var descriptions: [String] = []
        
        if !activeFilters.selectedBrands.isEmpty {
            
            descriptions.append(contentsOf: activeFilters.selectedBrands)
        }
        
        if !activeFilters.selectedModels.isEmpty {
            descriptions.append(contentsOf: activeFilters.selectedModels)
        }
        
        if descriptions.isEmpty {
            return "No Filters"
        } else {
            
            return descriptions.joined(separator: ", ")
        }
    }
}
