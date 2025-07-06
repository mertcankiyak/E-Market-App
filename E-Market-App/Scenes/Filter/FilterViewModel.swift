//
//  FilterViewModel.swift
//  E-Market-App
//
//  Created by Mert on 5.07.2025.
//

import Foundation

class FilterViewModel {
    
    
    private let allBrands: [String]
    private let allModels: [String]
    
    private(set) var filteredBrands: [String]
    private(set) var filteredModels: [String]
    
    var currentFilterData: FilterData
    
    
    init(availableBrands: [String], availableModels: [String], initialFilters: FilterData) {
        self.allBrands = availableBrands.sorted()
        self.allModels = availableModels.sorted()
        self.filteredBrands = self.allBrands
        self.filteredModels = self.allModels
        self.currentFilterData = initialFilters
    }
        
    func searchBrands(with query: String) {
        if query.isEmpty {
            filteredBrands = allBrands
        } else {
            filteredBrands = allBrands.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
    
    func searchModels(with query: String) {
        if query.isEmpty {
            filteredModels = allModels
        } else {
            filteredModels = allModels.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
        
    func selectSortOption(_ option: SortOption) {
        currentFilterData.sortBy = option
    }
    
    func toggleBrandSelection(_ brand: String) {
        if currentFilterData.selectedBrands.contains(brand) {
            currentFilterData.selectedBrands.remove(brand)
        } else {
            currentFilterData.selectedBrands.insert(brand)
        }
    }
    
    func toggleModelSelection(_ model: String) {
        if currentFilterData.selectedModels.contains(model) {
            currentFilterData.selectedModels.remove(model)
        } else {
            currentFilterData.selectedModels.insert(model)
        }
    }
}
