//
//  UIStackView.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 06.03.2022.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = spacing
        self.axis = axis
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
