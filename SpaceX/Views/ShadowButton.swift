//
//  ShadowButton.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 23.03.2022.
//

import UIKit

class ShadowButton: UIButton {
    
    private var title: String
    private var imageName: String
    
    private lazy var whiteShadow: CALayer = {
        let shadow = CALayer()
        shadow.shadowColor = UIColor.white.cgColor
        shadow.shadowOffset = CGSize(width: -2, height: -2)
        shadow.shadowOpacity = 1
        shadow.shadowRadius = 1.5
        shadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        return shadow
    }()
    
    private lazy var greyShadow: CALayer = {
        let layer = CALayer()
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 1.5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        return layer
    }()
    
    override var isHighlighted: Bool {
        willSet {
            if newValue { // if is highlighted
                tintColor = .champagne
                imageView?.tintColor = .champagne
                hideShadows()
            } else { // not highlighted
                tintColor = .coral
                imageView?.tintColor = .coral
                showShadows()
            }
        }
    }
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShadows()
    }
    
    private func setupView() {
        semanticContentAttribute = .forceRightToLeft
        setTitle(title, for: .normal)
        setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        setTitleColor(.coral, for: .normal)
        setTitleColor(.champagne, for: .highlighted)
        backgroundColor = .white
        tintColor = .coral
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layer.cornerRadius = frame.height / 2
        
        setInsets()
        addShadows()
    }
    
    private func setInsets() {
        let title = title(for: .normal)
        if title == nil || title == "" { // check for empty string is needed for ShadowButton which is only an image
            contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        } else {
            contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
            imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
}

// MARK: - Shadows
extension ShadowButton {
    
    private func addShadows() {
        layer.insertSublayer(whiteShadow, at: 0)
        layer.insertSublayer(greyShadow, at: 0)
        layer.cornerRadius = bounds.height / 2
    }
    
    private func updateShadows() {
        whiteShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        greyShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        layer.cornerRadius = bounds.height / 2
    }
    
    private func hideShadows() {
        whiteShadow.shadowOpacity = 0.0
        greyShadow.shadowOpacity = 0.0
    }
    
    private func showShadows() {
        whiteShadow.shadowOpacity = 1.0
        greyShadow.shadowOpacity = 1.0
    }
}

