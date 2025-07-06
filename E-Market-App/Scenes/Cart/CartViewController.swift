//
//  CartViewController.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import UIKit

class CartViewController: UIViewController {
    
    let viewModel: CartViewModel
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        return tableView
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
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total:"
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
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your cart is empty."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(CartViewController.self, action: #selector(didTapComplete), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        bindViewModel()
    }
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCartData()
    }
    
    
    @objc private func didTapComplete() {
        AlertManager.shared.showAlert(for: .orderCompleted, on: self)
    }
    
    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            
            
            let isCartEmpty = self.viewModel.cartItems.isEmpty
            
            self.tableView.isHidden = isCartEmpty
            self.bottomContainerView.isHidden = isCartEmpty
            
            self.emptyCartLabel.isHidden = !isCartEmpty
            
            if !isCartEmpty {
                self.tableView.reloadData()
                self.priceLabel.text = self.viewModel.totalPriceString
            }
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "My Cart"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(bottomContainerView)
        view.addSubview(emptyCartLabel)
        
        let priceStackView = UIStackView(arrangedSubviews: [totalLabel, priceLabel])
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        
        let bottomStackView = UIStackView(arrangedSubviews: [priceStackView, completeButton])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.spacing = 16
        bottomStackView.alignment = .center
        
        bottomContainerView.addSubview(bottomStackView)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: padding),
            bottomStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: padding),
            bottomStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -padding),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -padding),
            
            completeButton.widthAnchor.constraint(equalToConstant: 150),
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
}


