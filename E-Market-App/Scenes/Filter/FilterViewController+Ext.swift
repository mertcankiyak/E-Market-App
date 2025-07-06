//
//  FilterViewController+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortTableView {
            return SortOption.allCases.count
        } else if tableView == brandTableView {
            return viewModel.filteredBrands.count
        } else if tableView == modelTableView {
            return viewModel.filteredModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sortTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier, for: indexPath) as! SortByCell
            let option = SortOption.allCases[indexPath.row]
            let isSelected = viewModel.currentFilterData.sortBy == option
            cell.configure(title: option.rawValue, isSelected: isSelected)
            return cell
        } else if tableView == brandTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxCell.identifier, for: indexPath) as? CheckboxCell else {
                return UITableViewCell()
            }
            let brand = viewModel.filteredBrands[indexPath.row]
            let isSelected = viewModel.currentFilterData.selectedBrands.contains(brand)
            
            cell.configure(title: brand, isSelected: isSelected)
            
            return cell
        } else if tableView == modelTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxCell.identifier, for: indexPath) as? CheckboxCell else {
                return UITableViewCell()
            }
            
            let model = viewModel.filteredModels[indexPath.row]
            let isSelected = viewModel.currentFilterData.selectedModels.contains(model)
            
            cell.configure(title: model, isSelected: isSelected)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sortTableView {
            let selectedOption = SortOption.allCases[indexPath.row]
            viewModel.selectSortOption(selectedOption)
            tableView.reloadData()
        } else if tableView == brandTableView {
            let selectedBrand = viewModel.filteredBrands[indexPath.row]
            viewModel.toggleBrandSelection(selectedBrand)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if tableView == modelTableView {
            let selectedModel = viewModel.filteredModels[indexPath.row]
            viewModel.toggleModelSelection(selectedModel)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandSearchbar {
            viewModel.searchBrands(with: searchText)
            brandTableView.reloadData()
        } else if searchBar == modelSearchbar {
            viewModel.searchModels(with: searchText)
            modelTableView.reloadData()
        }
        self.view.setNeedsLayout()
    }
}
