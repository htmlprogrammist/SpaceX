//
//  RocketsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class RocketsViewController: UICollectionViewController {
    
    private var rockets = [Rocket]()
    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowUpAndDown"), style: .plain, target: self, action: #selector(sortButtonTapped))
        view.backgroundColor = .glaucous
        collectionView.backgroundColor = .transparent
        collectionView.register(RocketsCollectionViewCell.self, forCellWithReuseIdentifier: RocketsCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        getRockets()
    }
    
    @objc private func sortButtonTapped() {
        print("Tapped")
    }
    
    private func getRockets() {
        let request = NetworkRequest(urlString: "https://api.spacexdata.com/v4/rockets")
        networkManager.perform(request: request) { [weak self] (result: Result<[Rocket], NetworkManagerError>) in
            
            guard let strongSelf = self else {
                self?.alertForError(title: "An unexpected error has occurred", message: "Please, restart application")
                return
            }
            
            switch result {
            case .success(let rockets):
                strongSelf.rockets = rockets
                
                DispatchQueue.main.async {
                    strongSelf.collectionView.reloadData()
                }
            case .failure(let error):
                strongSelf.handleError(error: error)
            }
        }
    }
}

// MARK: - UICollectionView
extension RocketsViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rockets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketsCollectionViewCell.identifier, for: indexPath) as? RocketsCollectionViewCell else { return UICollectionViewCell() }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = RocketDetailViewController()
        destination.rocket = rockets[indexPath.row]
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 30, left: 18, bottom: 30, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2 * 18
        let height = width / (377 / 360)
        return CGSize(width: width, height: 360)
    }
}
