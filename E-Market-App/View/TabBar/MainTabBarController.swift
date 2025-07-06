//
//  MainTabbarController.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .didUpdateCart, object: nil)
        updateCartBadge()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTabs() {
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        homeVC.navigationItem.title = "E-Market"
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let cartVC = CartViewController(viewModel:  CartViewModel())
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        
        let favoritesVC = FavoriteViewController(viewModel: FavoriteViewModel())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [homeNav, cartVC, favoritesVC, profileVC]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 21/255, green: 90/255, blue: 243/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    @objc private func updateCartBadge() {
        let itemCount = CoreDataManager.shared.getTotalItemCountInCart()
        
        if let cartTab = tabBar.items?[1] {
            if itemCount > 0 {
                cartTab.badgeValue = "\(itemCount)"
            } else {
                cartTab.badgeValue = nil
            }
        }
    }
}
