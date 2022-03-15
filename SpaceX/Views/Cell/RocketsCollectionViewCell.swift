//
//  RocketsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "rocketsCell"
    
    private let titleData = ["First launch", "Launch cost", "Success"]
    private var subtitleData = [String]()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 20)
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(rocket: Rocket) {
        imageView.loadImage(for: rocket.flickrImages?.first ?? "")
        titleLabel.text = rocket.name
        
        // getting String from Rocket, parsing it with entered dateFormat and then format date to normal view
        // Types: (Unformatted) String -> Date -> (Formatted) String
        let formattedDateOfFirstFlight = (rocket.firstFlight ?? "1970-01-01").parseDate(dateFormat: "yyyy-MM-dd").formatDate()
        subtitleData = ["\(formattedDateOfFirstFlight)", "\(rocket.costPerLaunch ?? 0)$", "\(rocket.successRatePct ?? 0)%"]
        
        for subview in mainStackView.arrangedSubviews {
            mainStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        for i in 0..<3 {
            let mainLabel = UILabel(text: titleData[i], weight: .bold)
            let subtitleLabel = UILabel(text: subtitleData[i], weight: .bold, color: .slateGray)
            let subStackView = UIStackView(arrangedSubviews: [mainLabel, subtitleLabel], spacing: 2)
            mainStackView.addArrangedSubview(subStackView)
        }
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainStackView)
        
        // Shadows
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.withAlphaComponent(0.37).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 20.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 30/47),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
