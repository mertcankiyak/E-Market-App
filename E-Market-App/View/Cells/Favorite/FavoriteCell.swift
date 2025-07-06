//
//  FavoriteCell.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    static let identifier = "HomeProductCell"
        
    var onAddToCartTapped: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemGray3
        button.backgroundColor = .white.withAlphaComponent(0.7)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkText
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addToCartButton.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapAddToCart() {
        onAddToCartTapped?()
    }
    
    @objc private func didTapFavorite() {
        onFavoriteTapped?()
    }
    
    private func configure(name: String?, price: String?, isFavorite: Bool, imageURL: String?) {
        self.nameLabel.text = name
        self.priceLabel.text = "\(price ?? "0") ₺"
        
        let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton.setImage(starImage, for: .normal)
        self.favoriteButton.tintColor = isFavorite ? .systemYellow : .systemGray3
        
        if let url = imageURL {
            self.productImageView.loadImage(from: url)
        } else {
            self.productImageView.image = UIImage(systemName: "photo.artframe")
        }
    }
    
    func configure(with product: FavoriteItemEntity, isFavorite: Bool) {
        configure(name: product.name, price: product.price, isFavorite: isFavorite, imageURL: product.imageURL)
    }
        
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(productImageView)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(priceLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(addToCartButton)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            
            addToCartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        productImageView.image = nil
    }
}
