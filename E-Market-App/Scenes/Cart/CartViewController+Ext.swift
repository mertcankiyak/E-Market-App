//
//  CartViewController+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            fatalError("Could not dequeue CartItemCell")
        }
        
        let item = viewModel.cartItems[indexPath.row]
        cell.configure(with: item)
        
        cell.onIncrement = { [weak self] in
            self?.viewModel.incrementQuantity(for: item)
        }
        
        cell.onDecrement = { [weak self] in
            self?.viewModel.decrementQuantity(for: item)
        }
        
        return cell
    }
}
