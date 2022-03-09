//
//  RocketsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketsCollectionViewCell: UICollectionViewCell {
    
    public var rocket: Rocket?
    static let identifier = "rocketsCell"
    private lazy var rocketCard = RocketCardView(rocket: rocket)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViewAndConstraints()
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
