//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class LaunchesViewController: UICollectionViewController {
    
//    private var rockets = [Rocket]()
    private let networkManager: NetworkManagerProtocol
    private let transitionManager: TransitionManagerProtocol
    
//    public var selectedCell: RocketsCollectionViewCell? // a cell that was selected (tapped)
    
    init(networkManager: NetworkManagerProtocol, transitionManager: TransitionManagerProtocol) {
        self.networkManager = networkManager
        self.transitionManager = transitionManager
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
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
