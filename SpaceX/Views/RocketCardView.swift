//
//  RocketCardView.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 08.03.2022.
//

import UIKit

final class RocketCardView: UIView {
    
    public var rocket: Rocket?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "")
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 30)
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    init(rocket: Rocket?) {
        if let rocket = rocket {
            self.rocket = rocket
        }
        super.init(frame: .zero)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        // unwrapping all needed properties
        guard let flickrImages = rocket?.flickrImages,
              let name = rocket?.name,
              let firstFlight = rocket?.firstFlight,
              let costPerLaunch = rocket?.costPerLaunch,
              let success = rocket?.successRatePct
        else { return }
        
//        imageView.image = rocket?.flickrImages[0..<rocket?.flickrImages.count]
        let randomIndex = Int.random(in: 0..<flickrImages.count)
        imageView.loadImage(for: flickrImages[randomIndex])
        titleLabel.text = name
        let formattedDateOfFirstFlight = formatDate(input: firstFlight)
        
        let titleData = ["First launch", "Launch cost", "Success"]
        let subtitleData = ["\(formattedDateOfFirstFlight)", "\(costPerLaunch)$", "\(success)%"]
        
        for i in 0..<3 {
            let mainLabel = UILabel(text: titleData[i], weight: .bold)
            let subtitleLabel = UILabel(text: subtitleData[i], weight: .bold, color: .slateGray)
            let subStackView = UIStackView(arrangedSubviews: [mainLabel, subtitleLabel], spacing: 4)
            mainStackView.addArrangedSubview(subStackView)
        }
        
        contentView.addSubview(mainStackView)
        addSubview(contentView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
    
    private func formatDate(input: String) -> String {
        let parseDateFormatter = DateFormatter()
        parseDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = parseDateFormatter.date(from: input) else { return "January 1, 1970" }
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.locale = Locale(identifier: "en_US")
        convertDateFormatter.dateStyle = .long
        convertDateFormatter.timeStyle = .none
        return convertDateFormatter.string(from: date)
    }
}
