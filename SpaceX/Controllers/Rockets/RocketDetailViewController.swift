//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketDetailViewController: UIViewController, UIScrollViewDelegate {
    
    public let rocket: Rocket
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .clear
        view.autoresizingMask = .flexibleHeight
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = true
        view.delegate = self
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
        view.autoresizingMask = .flexibleHeight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 0
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        layer.locations = [0.5, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
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
        
        containerView.addSubview(textView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 383/414),
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            textView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32)
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
        if subView == imageView {
            let imageViewCopy = UIImageView(image: imageView.image)
            imageViewCopy.contentMode = imageView.contentMode
            imageViewCopy.clipsToBounds = true
            imageViewCopy.layer.cornerRadius = 20
            return imageViewCopy
        } else if subView == titleLabel {
            let labelCopy = UILabel()
            labelCopy.text = titleLabel.text
            labelCopy.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            labelCopy.textColor = .black
            return labelCopy
        }
        
        return UIView()
    }
}
