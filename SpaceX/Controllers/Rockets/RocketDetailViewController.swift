//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketDetailViewController: UIViewController {
    
    public let rocket: Rocket
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.loadImage(for: rocket.flickrImages?.first ?? "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        layer.locations = [0.5, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = rocket.name
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevronBackward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .coral
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descriptionView = DescriptionView(text: rocket.rocketDescription ?? "")
    private lazy var overviewView: OverviewView = {
        let labels = ["First launch", "Launch cost", "Success", "Mass", "Height", "Diameter"]
        let formattedDateOfFirstFlight = (rocket.firstFlight ?? "1970-01-01").parseDate(dateFormat: "yyyy-MM-dd").formatDate()
        let data = [formattedDateOfFirstFlight, "\(rocket.costPerLaunch ?? 0)$", "\(rocket.successRatePct ?? 0)%", "\(rocket.mass?.kg ?? 0) kg", "\(rocket.height?.meters ?? 0) meters", "\(rocket.diameter?.meters ?? 0) meters"]
        let overview = OverviewView(titleText: "Overview", labels: labels, data: data)
        return overview
    }()
    private lazy var imageCollectionView = ImagesView(imagesUrls: rocket.flickrImages ?? [])
    private lazy var enginesView: OverviewView = {
        let labels = ["Type", "Layout", "Version", "Amount", "Propellant 1", "Propellant 2"]
        let data = [rocket.engines?.type, rocket.engines?.layout, rocket.engines?.version, "\(rocket.engines?.number ?? 0)", rocket.engines?.propellant1, rocket.engines?.propellant2]
        let overview = OverviewView(titleText: "Engines", labels: labels, data: data)
        return overview
    }()
    private lazy var firstStageView: OverviewView = {
        let labels = ["Reusable", "Engines amount", "Fuel amount", "Burning time", "Thrust (sea level)", "Thrust (vacuum)"]
        let formattedTrueFalse = (rocket.firstStage?.reusable ?? false) ? "Yes": "No"
        let data = [formattedTrueFalse, "\(rocket.firstStage?.engines ?? 0)", "\(rocket.firstStage?.fuelAmountTons ?? 0) tons", "\(rocket.firstStage?.burnTimeSEC ?? 0) seconds", "\(rocket.firstStage?.thrustSeaLevel?.kN ?? 0) kN", "\(rocket.firstStage?.thrustVacuum?.kN ?? 0) kN"]
        let overview = OverviewView(titleText: "First stage", labels: labels, data: data)
        return overview
    }()
    private lazy var secondStageView: OverviewView = {
        let labels = ["Reusable", "Engines amount", "Fuel amount", "Burning time", "Thrust"]
        let formattedTrueFalse = (rocket.secondStage?.reusable ?? false) ? "Yes": "No"
        let data = [formattedTrueFalse, "\(rocket.secondStage?.engines ?? 0)", "\(rocket.secondStage?.fuelAmountTons ?? 0) tons", "\(rocket.secondStage?.burnTimeSEC ?? 0) seconds", "\(rocket.secondStage?.thrust?.kN ?? 0) kN"]
        let overview = OverviewView(titleText: "Second stage", labels: labels, data: data)
        return overview
    }()
    private lazy var landingLegsView: OverviewView = {
        let labels = ["Amount", "Material"]
        let data = ["\(rocket.landingLegs?.number ?? 0)", rocket.landingLegs?.material]
        let overview = OverviewView(titleText: "Landing legs", labels: labels, data: data)
        return overview
    }()
    
    private lazy var materialsLabel = UILabel(text: "Materials", size: 24, weight: .bold)
    private lazy var wikiButton: ShadowButton = {
        let button = ShadowButton(title: "Wiki", imageName: "link")
        button.addTarget(self, action: #selector(openWiki), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var footer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(rocket: Rocket) {
        self.rocket = rocket
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.transition(with: contentView, duration: 0.4, options: [.transitionFlipFromTop, .curveEaseOut], animations: { [self] in
            contentView.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = imageView.layer.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.transition(with: contentView, duration: 0.15, options: [.transitionFlipFromTop, .curveEaseOut], animations: { [self] in
            contentView.alpha = 0
        }, completion: nil)
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        
        scrollView.addSubview(topView)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        topView.addSubview(imageView)
        imageView.layer.addSublayer(gradientLayer)
        topView.addSubview(titleLabel)
        
        showDetails()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 383/414),
            
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
        ])
    }
    
    private func showDetails() {
        scrollView.addSubview(contentView)
        
        [descriptionView, overviewView, imageCollectionView, enginesView, firstStageView, secondStageView, landingLegsView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(materialsLabel)
        contentView.addSubview(wikiButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            overviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewView.topAnchor.constraint(equalTo: descriptionView.descriptionLabel.bottomAnchor, constant: 30),
            overviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imageCollectionView.topAnchor.constraint(equalTo: overviewView.mainStackView.bottomAnchor, constant: 20),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            enginesView.topAnchor.constraint(equalTo: imageCollectionView.collectionView.bottomAnchor, constant: 30),
            enginesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            enginesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            firstStageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            firstStageView.topAnchor.constraint(equalTo: enginesView.mainStackView.bottomAnchor, constant: 30),
            firstStageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            secondStageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            secondStageView.topAnchor.constraint(equalTo: firstStageView.mainStackView.bottomAnchor, constant: 30),
            secondStageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            landingLegsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            landingLegsView.topAnchor.constraint(equalTo: secondStageView.mainStackView.bottomAnchor, constant: 30),
            landingLegsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            materialsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            materialsLabel.topAnchor.constraint(equalTo: landingLegsView.mainStackView.bottomAnchor, constant: 20),
            wikiButton.topAnchor.constraint(equalTo: materialsLabel.bottomAnchor, constant: 20),
            wikiButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        contentView.addSubview(footer)
        NSLayoutConstraint.activate([
            footer.topAnchor.constraint(equalTo: wikiButton.bottomAnchor),
            footer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func closeVC() {
        dismiss(animated: true)
    }
    
    @objc func openWiki() {
        let destination = UINavigationController(rootViewController: RocketWikiViewController(url: rocket.wikipedia ?? ""))
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }
}

extension RocketDetailViewController: Transitionable {
    
    func viewsToAnimate() -> [UIView] {
        return [imageView, titleLabel]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        switch subView {
        case is UIImageView:
            let imageViewCopy = UIImageView(image: imageView.image)
            imageViewCopy.contentMode = imageView.contentMode
            imageViewCopy.clipsToBounds = true
            return imageViewCopy
        case is UILabel:
            let labelCopy = UILabel()
            labelCopy.text = titleLabel.text
            labelCopy.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            labelCopy.textColor = .black
            return labelCopy
        default:
            return UIView()
        }
    }
}
