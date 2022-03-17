//
//  LaunchpadsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 17.03.2022.
//

import UIKit

final class LaunchpadsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "launchpadsCell"
    
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
