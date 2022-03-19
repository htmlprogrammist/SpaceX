//
//  OverviewView.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 19.03.2022.
//

import UIKit

final class OverviewView: UIView {
    
    private var titleText: String
    private var labels: [String]
    private var data: [String]
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel = UILabel(text: titleText, size: 24, weight: .bold)
    
    init(titleText: String, labels: [String], data: [String]) {
        self.titleText = titleText
        self.labels = labels
        self.data = data
        super.init(frame: .zero)
        
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewAndConstraints() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
