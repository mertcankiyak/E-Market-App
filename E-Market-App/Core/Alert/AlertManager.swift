//
//  AlertManager.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

enum AlertType : Equatable {
    case itemAddedToCart
    case itemRemovedFromCart
    case itemAddedToFavorites
    case itemRemovedFromFavorites
    case orderCompleted
    case custom(title: String, message: String)
}

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    

    func showAlert(for type: AlertType, on viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertData = self.data(for: type)
            let alertController = UIAlertController(
                title: alertData.title,
                message: alertData.message,
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func data(for type: AlertType) -> (title: String, message: String) {
        switch type {
        case .itemAddedToCart:
            return ("Success", "Item has been added to your cart.")
        case .itemRemovedFromCart:
            return ("Success", "Item has been removed from your cart.")
        case .itemAddedToFavorites:
            return ("Success", "Item has been added to your favorites.")
        case .itemRemovedFromFavorites:
            return ("Success", "Item has been removed from your favorites.")
        case .orderCompleted:
            return ("Thank You!", "Your order has been completed successfully.")
        case .custom(let title, let message):
            return (title, message)
        }
    }
}
