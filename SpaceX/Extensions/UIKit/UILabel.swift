//
//  UILabel.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 06.03.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, color: UIColor = .black) {
        self.init()
        self.text = text
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
