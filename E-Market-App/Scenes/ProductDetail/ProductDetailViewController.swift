//
//  ProductDetailViewController.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private var viewModel: ProductDetailViewModel
        
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemYellow
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .init(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Price:"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkText
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)
        return button
    }()
    
    init(product: ProductModelElement) {
        self.viewModel = ProductDetailViewModel(product: product)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithData()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    private func configureWithData() {
        let product = viewModel.product
        title = product.name
        titleLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "\(product.price ?? "0") ₺"
        
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
        
        if let url = product.image {
            self.productImageView.loadImage(from: url)
        } else {
            self.productImageView.image = UIImage(systemName: "photo.artframe")
        }
    }
    
    private func bindViewModel() {
        viewModel.onFavoriteStatusChanged = { [weak self] isFavorite in
            self?.updateFavoriteButton(isFavorite: isFavorite)
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapFavorite() {
        viewModel.toggleFavorite()
    }
    
    @objc private func didTapAddToCart() {
        viewModel.addToCart()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(scrollView)
        view.addSubview(bottomContainerView)
        scrollView.addSubview(contentView)
        contentView.addSubview(productImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        let priceStackView = UIStackView(arrangedSubviews: [priceInfoLabel, priceLabel])
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        
        let bottomMainStackView = UIStackView(arrangedSubviews: [priceStackView, addToCartButton])
        bottomMainStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomMainStackView.spacing = 16
        bottomMainStackView.alignment = .center
        
        bottomContainerView.addSubview(bottomMainStackView)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomMainStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: padding),
            bottomMainStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: padding),
            bottomMainStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -padding),
            bottomMainStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -padding),
            
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
           
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 12),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
