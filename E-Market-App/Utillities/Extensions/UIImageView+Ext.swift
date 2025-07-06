//
//  UIImageView+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    
    func loadImage(from urlString: String) {
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo:self.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] result in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    if let imageToCache = UIImage(data: data) {
                        imageCache.setObject(imageToCache, forKey: urlString as NSString)
                        self.image = imageToCache
                    }
                case .failure(let error):
                    print("Image download error: \(error.localizedDescription)")
                }
            }
        }
    }
}
