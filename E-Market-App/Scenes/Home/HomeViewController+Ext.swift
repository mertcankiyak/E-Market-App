//
//  HomeViewController+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.searchProducts(with: query)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchProducts(with: "")
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCell.identifier, for: indexPath) as? HomeProductCell else {
            fatalError("Could not dequeue HomeProductCell")
        }
        
        let product = viewModel.displayedProducts[indexPath.item]
        let isFavorite = viewModel.isProductFavorite(productId: product.id)
        
        cell.configure(with: product, isFavorite: isFavorite)
        
        cell.onAddToCartTapped = { [weak self] in
            self?.viewModel.addToCart(product: product)
        }
        
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.toggleFavorite(product: product)
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.displayedProducts[indexPath.item]
        let detailVC = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight * 1.5) {
            viewModel.loadProductsFromAPI()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let interItemSpacing: CGFloat = 12
        
        let availableWidth = view.frame.width - (padding * 2) - interItemSpacing
        let itemWidth = availableWidth / 2
        
        let itemHeight = itemWidth * 1.7
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 16
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
