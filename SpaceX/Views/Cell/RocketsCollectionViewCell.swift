//
//  RocketsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class RocketsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "rocketsCell"
    lazy var rocketCard = RocketCardView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViewAndConstraints() {
        contentView.addSubview(rocketCard)
        rocketCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rocketCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rocketCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rocketCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rocketCard.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
}
