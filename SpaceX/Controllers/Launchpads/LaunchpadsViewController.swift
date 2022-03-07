//
//  LaunchpadsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class LaunchpadsViewController: UIViewController {
    
    // https://github.com/r-spacex/SpaceX-API/tree/master/docs/launchpads/v4
    lazy var networkManager: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        let networkManager = NetworkManager(session: URLSession(configuration: configuration))
        return networkManager
    }()
    
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
