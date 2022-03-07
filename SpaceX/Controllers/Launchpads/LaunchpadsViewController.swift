//
//  LaunchpadsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class LaunchpadsViewController: UIViewController {
    
    private var networkManager: NetworkManagerProtocol
    
    
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .glaucous
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        
    }
    
    private func setConstraints() {
        
    }
}
