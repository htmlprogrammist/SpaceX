//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketDetailViewController: UIViewController, UIScrollViewDelegate {
    
    public let rocket: Rocket
    private var startX: CGFloat = 0
    private weak var navigationControllerDelegate: NavigationControllerDelegate?
    
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
        // MARK: Add dimming effect (gradient)
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
    
    let textView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ac dapibus metus. Vivamus ac nisl varius, tempor odio sit amet, eleifend nulla. Suspendisse potenti. Integer feugiat semper sapien, sed dictum mauris rhoncus eu. Aliquam auctor, dui et sagittis pretium, dui tortor vehicula nulla, at viverra nibh turpis eu orci. Nam ac est id orci ultricies lobortis ut vitae mauris. Pellentesque in euismod mauris, eget posuere turpis. Pellentesque semper finibus nunc vel tincidunt. Ut lacus orci, lacinia tincidunt consequat at, luctus non diam. Nam in molestie metus, porta lacinia dui. Fusce quis purus ac nulla rhoncus placerat id ac velit. Phasellus dapibus pretium enim, at imperdiet lacus pharetra id. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam facilisis sollicitudin erat, eu ullamcorper neque sollicitudin sit amet."
        return textView
    }()
    
    init(rocket: Rocket) {
        self.rocket = rocket
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("View deinit.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        setupView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationControllerDelegate = navigationController?.delegate as? NavigationControllerDelegate
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textView)
        
        imageView.loadImage(for: rocket.flickrImages?.first ?? "")
        titleLabel.text = rocket.name
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
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            textView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32)
        ])
    }
}

extension RocketDetailViewController {
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        let percent = min(1, max(0, (translation.x - startX)/200))
        
        switch sender.state {
        case .began:
            startX = translation.x
            navigationControllerDelegate?.interactiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        case .changed:
            navigationControllerDelegate?.interactiveTransition?.update(percent)
        case .ended:
            fallthrough
        case .cancelled:
            if sender.velocity(in: sender.view).x < 0 && percent < 0.5 {
                navigationControllerDelegate?.interactiveTransition?.cancel()
            } else {
                navigationControllerDelegate?.interactiveTransition?.finish()
            }
            navigationControllerDelegate?.interactiveTransition = nil
        default:
            break
        }
        
    }
}
