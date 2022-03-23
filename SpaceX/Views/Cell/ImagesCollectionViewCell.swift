//
//  ImagesCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 19.03.2022.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "imagesCell"
    
    lazy var backgroundViewCell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(backgroundViewCell)
        contentView.addSubview(imageView)
        
        // Shadows
        contentView.layer.cornerRadius = 7
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 7
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 3),
            imageView.topAnchor.constraint(equalTo: backgroundViewCell.topAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -3),
            imageView.bottomAnchor.constraint(equalTo: backgroundViewCell.bottomAnchor, constant: -3),
        ])
    }
}
