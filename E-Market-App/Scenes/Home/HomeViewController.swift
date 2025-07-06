//
//  HomeViewController.swift
//  E-Market-App
//
//  Created by Mert on 4.07.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var filtersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TextConstants.FilterConstants.filter
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var selectFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(didTapSelectFilter), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(HomeProductCell.self, forCellWithReuseIdentifier: HomeProductCell.identifier)
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No products found to display."
        label.textColor = .systemGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        searchBar.delegate = self
        bindViewModel()
        viewModel.fetchInitialData()
    }
    
    @objc private func didTapSelectFilter() {
        let filterData = viewModel.getAvailableFilterOptions()
        let initialFilters = viewModel.activeFilters
        
        let filterVM = FilterViewModel(
            availableBrands: filterData.brands,
            availableModels: filterData.models,
            initialFilters: initialFilters
        )
        let filterVC = FilterViewController(viewModel: filterVM)
        let nav = UINavigationController(rootViewController: filterVC)
        present(nav, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            
            let filterDescription = self.viewModel.getActiveFiltersDescription()
            if filterDescription == "No Filters" {
                self.filtersLabel.text = TextConstants.HomeConstants.filters
                self.filtersLabel.textColor = .darkGray
                self.filtersLabel.font = .systemFont(ofSize: 18, weight: .regular)
            } else {
                self.filtersLabel.text = filterDescription
                self.filtersLabel.textColor = .systemBlue
                self.filtersLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            }

            switch state {
            case .loading:
                self.activityIndicator.startAnimating()
                self.collectionView.isHidden = true
                self.emptyStateLabel.isHidden = true
            case .success:
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.emptyStateLabel.isHidden = true
                self.collectionView.reloadData()
            case .error(let message):
                self.activityIndicator.stopAnimating()
                self.showErrorAlert(message: message)
            case .empty:
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = true
                self.emptyStateLabel.isHidden = false
            }
        }
        
        viewModel.onFavoritesUpdated = { [weak self] in
            self?.collectionView.reloadData()
            
        }
        
        viewModel.onActionCompleted = { [weak self] alertType in
            guard let self = self else { return }
            AlertManager.shared.showAlert(for: alertType, on: self)
        }
    }
    
    // MARK: - Setup
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(filtersLabel)
        view.addSubview(selectFilterButton)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            
            filtersLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: padding),
            filtersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            selectFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            selectFilterButton.centerYAnchor.constraint(equalTo: filtersLabel.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: padding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

