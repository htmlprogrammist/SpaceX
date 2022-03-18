//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketDetailViewController: UIViewController {
    
    public let rocket: Rocket
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.bounces = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var gradientLayer: CAGradientLayer = {
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
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevronBackward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .coral
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var wikiButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(rocket: Rocket) {
        self.rocket = rocket
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imageV")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let label1 = UILabel(text: "Text", size: 24, weight: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.transition(with: containerView, duration: 0.6, options: .curveEaseInOut, animations: { [self] in
            containerView.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = imageView.layer.bounds
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        imageView.loadImage(for: rocket.flickrImages?.first ?? "")
        imageView.layer.addSublayer(gradientLayer)
        
        scrollView.addSubview(titleLabel)
        titleLabel.text = rocket.name
        
        scrollView.addSubview(closeButton)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(imageView1)
        containerView.addSubview(label1)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 383/414),
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            closeButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            
            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            imageView1.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            imageView1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            imageView1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20),
            
            label1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            label1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            label1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 20),
        ])
    }
    
    @objc func closeVC() {
        dismiss(animated: true)
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
            imageViewCopy.layer.cornerRadius = 20
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
