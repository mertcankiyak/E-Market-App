//
//  CartItemCell.swift
//  E-Market-App
//
//  Created by Mert on 6.07.2025.
//


import UIKit

class CartItemCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
    
    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkText
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var decrementButton: UIButton = createStepperButton(with: "-")
    private lazy var incrementButton: UIButton = createStepperButton(with: "+")
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stepperStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decrementButton, quantityLabel, incrementButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        selectionStyle = .none
        
        let mainStackView = UIStackView(arrangedSubviews: [infoStackView, stepperStackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            stepperStackView.widthAnchor.constraint(equalToConstant: 120),
            quantityLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        incrementButton.addTarget(self, action: #selector(didTapIncrement), for: .touchUpInside)
        decrementButton.addTarget(self, action: #selector(didTapDecrement), for: .touchUpInside)
    }
    
    func configure(with item: CartItemEntity) {
        nameLabel.text = item.name
        priceLabel.text = "\(item.price ?? "0") ₺"
        quantityLabel.text = "\(item.quantity)"
    }
    
    @objc private func didTapIncrement() { onIncrement?() }
    @objc private func didTapDecrement() { onDecrement?() }
    
    private func createStepperButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }
}
