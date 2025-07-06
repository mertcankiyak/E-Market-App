//
//  UIImageView+Ext.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

// Resimleri hafızada tutmak için bir cache objesi oluşturalım.
// Bu, aynı resmin tekrar tekrar indirilmesini engeller.
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    /// Verilen bir URL string'inden asenkron olarak resim yükler.
    /// Yükleme sırasında bir activity indicator gösterir.
    /// İndirilen resimleri cache'ler.
    /// - Parameter urlString: Yüklenecek resmin URL'si (String formatında).
    func loadImage(from urlString: String) {
        // Yüklemeye başlamadan önce mevcut resmi temizle.
        self.image = nil
        
        // Önce cache'i kontrol et. Eğer resim cache'te varsa, network'e gitme.
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // URL'in geçerli olduğundan emin ol.
        guard let url = URL(string: urlString) else {
            // Geçersiz URL durumunda placeholder bir resim gösterebilirsiniz.
            // self.image = UIImage(named: "placeholder")
            return
        }
        
        // Activity indicator'ı oluştur ve başlat.
        let activityIndicator = UIActivityIndicatorView(style: .medium) // veya .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo:self.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        // NetworkManager'ı kullanarak resmi indir.
        NetworkManager.shared.downloadImage(from: url) { [weak self] result in
            // İşlem bittiğinde her zaman ana thread'e dön. UI güncellemeleri burada yapılmalı.
            DispatchQueue.main.async {
                // Activity indicator'ı durdur ve kaldır.
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    // İndirilen veriden bir UIImage oluştur.
                    if let imageToCache = UIImage(data: data) {
                        // Resmi cache'e ekle.
                        imageCache.setObject(imageToCache, forKey: urlString as NSString)
                        // Ve UIImageView'a ata.
                        self.image = imageToCache
                    }
                case .failure(let error):
                    // Hata durumunda placeholder bir resim göster.
                    // self.image = UIImage(named: "placeholder_error")
                    print("Image download error: \(error.localizedDescription)")
                }
            }
        }
    }
}
