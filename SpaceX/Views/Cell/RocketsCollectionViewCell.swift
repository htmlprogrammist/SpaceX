//
//  RocketsCollectionViewCell.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "rocketsCell"
    public var rocket: Rocket?
    
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
        let stackView = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 30)
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
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainStackView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [self] in
            imageView.loadImage(for: rocket?.flickrImages?.first ?? "")
            titleLabel.text = rocket?.name
            let formattedDateOfFirstFlight = formatDate(input: parseDate(input: rocket?.firstFlight ?? "1970-01-01"))
            
            let titleData = ["First launch", "Launch cost", "Success"]
            let subtitleData = ["\(formattedDateOfFirstFlight)", "\(rocket?.costPerLaunch ?? 0)$", "\(rocket?.successRatePct ?? 0)%"]
            
            for i in 0..<3 {
                let mainLabel = UILabel(text: titleData[i], weight: .bold)
                let subtitleLabel = UILabel(text: subtitleData[i], weight: .bold, color: .slateGray)
                let subStackView = UIStackView(arrangedSubviews: [mainLabel, subtitleLabel], spacing: 4)
                mainStackView.addArrangedSubview(subStackView)
            }
        })
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 240),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 27)
        ])
    }
}

extension RocketsCollectionViewCell {
    
    private func parseDate(input: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: input) else { return Date() }
        return date
    }
    
    private func formatDate(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: input)
    }
}
