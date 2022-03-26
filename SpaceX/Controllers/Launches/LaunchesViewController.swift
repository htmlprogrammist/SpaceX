//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class LaunchesViewController: UICollectionViewController {
    
    private var launches = [Launch]()
    private let networkManager: NetworkManagerProtocol
    private let transitionManager: TransitionManagerProtocol
    
    public var selectedCell: LaunchesCollectionViewCell? // a cell that was selected (tapped)
    
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
        collectionView.backgroundColor = .clear
        collectionView.register(LaunchesCollectionViewCell.self, forCellWithReuseIdentifier: LaunchesCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        fetchData()
    }
    
    private func fetchData() {
        let request = NetworkRequest(urlString: "https://api.spacexdata.com/v5/launches")
        networkManager.perform(request: request) { [weak self] (result: Result<[Launch], NetworkManagerError>) in
            
            guard let strongSelf = self else {
                self?.alertForError(title: "An unexpected error has occurred", message: "Please, restart application")
                return
            }
            
            switch result {
            case .success(let launches):
                strongSelf.launches = launches
                
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
extension LaunchesViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        launches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchesCollectionViewCell.identifier, for: indexPath) as? LaunchesCollectionViewCell else { return UICollectionViewCell() }
//        cell.configure(launch: launches[indexPath.row])
        cell.clipsToBounds = false
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? LaunchesCollectionViewCell
        
        let destination = LaunchDetailViewController()
        destination.hidesBottomBarWhenPushed = true
        destination.transitioningDelegate = transitionManager
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 18, bottom: 30, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2 * 18
        let height = width * 0.953
        return CGSize(width: width, height: height)
    }
}
/*
// MARK: - Transitioning
extension LaunchesViewController: Transitionable {
    
    func viewsToAnimate() -> [UIView] {
        <#code#>
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        <#code#>
    }
}
*/
