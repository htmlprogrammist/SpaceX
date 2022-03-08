//
//  UICollectionView.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 07.03.2022.
//

import UIKit

extension UICollectionView {
    convenience init(heightOfItem: CGFloat) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: heightOfItem)
        layout.scrollDirection = .vertical
        
        self.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .transparent
    }
}
