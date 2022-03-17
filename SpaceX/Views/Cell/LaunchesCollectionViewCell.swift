//
//  LaunchesCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 17.03.2022.
//

import UIKit

final class LaunchesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "launchesCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }
    
    private func setConstraints() {
        
    }
}
