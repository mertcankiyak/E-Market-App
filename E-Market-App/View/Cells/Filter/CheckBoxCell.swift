//
//  CheckBoxCell.swift
//  E-Market-App
//
//  Created by Mert on 5.07.2025.
//

// in Feature/Filter/View/CheckboxCell.swift
import UIKit

class CheckboxCell: UITableViewCell {
    
    static let identifier = "CheckboxCell"
    
    private let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkText
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        let stackView = UIStackView(arrangedSubviews: [checkboxImageView, titleLabel])
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            checkboxImageView.widthAnchor.constraint(equalToConstant: 22),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    public func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        checkboxImageView.image = UIImage(systemName: imageName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        checkboxImageView.image = nil
    }
}
