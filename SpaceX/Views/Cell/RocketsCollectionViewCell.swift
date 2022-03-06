//
//  RocketsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class RocketsCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 30)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        for i in 0..<3 {
            /*
            let mainLabel = UILabel(text: "Title")
            let subtitleLabel = UILabel(text: "Subtitle", color: .slateGray)
            /*
            let mainLabel = UILabel()
            mainLabel.text = "Title"
            let subtitleLabel = UILabel()
            subtitleLabel.text = "Subtitle"
            subtitleLabel.textColor = .slateGray
            */
            let subStackView = UIStackView(arrangedSubviews: [mainLabel, subtitleLabel])
            */
            let subStackView = UILabel(text: "Hello, World!", color: .slateGray)
            mainStackView.addArrangedSubview(subStackView)
        }
        
        contentView.addSubview(mainStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 240),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // если делаешь 20, то ошибка исчезает, но на экране так же пусто
            mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 27)
        ])
    }
}
