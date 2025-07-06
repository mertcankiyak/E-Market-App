//
//  FilterViewController.swift
//  E-Market-App
//
//  Created by Mert on 5.07.2025.
//

import UIKit

extension Notification.Name {
    static let didApplyFilters = Notification.Name("didApplyFiltersNotification")
}

class FilterViewController: UIViewController {
    
    var viewModel: FilterViewModel
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    let sortByLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort By"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    let sortTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(SortByCell.self, forCellReuseIdentifier: SortByCell.identifier)
        return tableView
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    let brandSearchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let brandTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.identifier)
        return tableView
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    let modelSearchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let modelTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.identifier)
        return tableView
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var sortTableViewHeightConstraint: NSLayoutConstraint!
    private var brandTableViewHeightConstraint: NSLayoutConstraint!
    private var modelTableViewHeightConstraint: NSLayoutConstraint!
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupDelegates()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeights()
    }
    
    private func setupNavigationBar() {
        title = "Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapClose))
    }
    
    private func setupDelegates() {
        sortTableView.dataSource = self
        sortTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.delegate = self
        modelTableView.dataSource = self
        modelTableView.delegate = self
        brandSearchbar.delegate = self
        modelSearchbar.delegate = self
    }
    
    private func setupUI() {
        applyButton.addTarget(self, action: #selector(didTapApplyFilters), for: .touchUpInside)
        
        func createSectionStack(label: UILabel, content: UIView) -> UIStackView {
            let stack = UIStackView(arrangedSubviews: [label, content])
            stack.axis = .vertical
            stack.spacing = 8
            return stack
        }
        
        func createSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = .systemGray4
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return separator
        }
        
        let sortSection = createSectionStack(label: sortByLabel, content: sortTableView)
        let brandSection = createSectionStack(label: brandLabel, content: brandSearchbar)
        let modelSection = createSectionStack(label: modelLabel, content: modelSearchbar)
        
        mainStackView.addArrangedSubview(sortSection)
        mainStackView.addArrangedSubview(createSeparator())
        mainStackView.addArrangedSubview(brandSection)
        mainStackView.addArrangedSubview(brandTableView)
        mainStackView.addArrangedSubview(createSeparator())
        mainStackView.addArrangedSubview(modelSection)
        mainStackView.addArrangedSubview(modelTableView)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainStackView)
        view.addSubview(applyButton)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -padding),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // Bu önemli
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        sortTableViewHeightConstraint = sortTableView.heightAnchor.constraint(equalToConstant: 0)
        brandTableViewHeightConstraint = brandTableView.heightAnchor.constraint(equalToConstant: 0)
        modelTableViewHeightConstraint = modelTableView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            sortTableViewHeightConstraint,
            brandTableViewHeightConstraint,
            modelTableViewHeightConstraint
        ])
    }
    
    private func updateTableViewHeights() {
        sortTableViewHeightConstraint.constant = sortTableView.contentSize.height
        brandTableViewHeightConstraint.constant = brandTableView.contentSize.height
        modelTableViewHeightConstraint.constant = modelTableView.contentSize.height
        view.layoutIfNeeded()
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapApplyFilters() {
        NotificationCenter.default.post(name: .didApplyFilters, object: viewModel.currentFilterData)
        dismiss(animated: true)
    }
}

