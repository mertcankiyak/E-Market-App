//
//  SortByCell.swift
//  E-Market-App
//
//  Created by Mert on 5.07.2025.
//


import UIKit

class SortByCell: UITableViewCell {
    static let identifier = "SortByCell"
    
    private let radioImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = .systemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [radioImageView, titleLabel])
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            radioImageView.widthAnchor.constraint(equalToConstant: 24),
            radioImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        let imageName = isSelected ? "largecircle.fill.circle" : "circle"
        radioImageView.image = UIImage(systemName: imageName)
        radioImageView.tintColor = .systemBlue
    }
}
