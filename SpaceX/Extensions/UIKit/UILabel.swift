//
//  UILabel.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 06.03.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, size: CGFloat = 14, weight: UIFont.Weight = .regular, color: UIColor = .black) {
        self.init()
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
