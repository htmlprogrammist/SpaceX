//
//  RocketsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketsViewController: UICollectionViewController {
    
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
        
        fetchData()
    }
    
    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: "Choose your option", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .coral
        
        let launchDateAlertAction = UIAlertAction(title: "First launch", style: .default) { [weak self] _ in
            self?.rockets.sort(by: { $0.firstFlight?.parseDate(dateFormat: "yyyy-MM-dd") ?? Date() < $1.firstFlight?.parseDate(dateFormat: "yyyy-MM-dd") ?? Date() })
            self?.collectionView.reloadData()
        }
        let launchCostAlertAction = UIAlertAction(title: "Launch cost", style: .default) { [weak self] _ in
            self?.rockets.sort(by: { ($0.costPerLaunch ?? 0) < ($1.costPerLaunch ?? 1) })
            self?.collectionView.reloadData()
        }
        let successRateAlertAction = UIAlertAction(title: "Success rate", style: .default) { [weak self] _ in
            self?.rockets.sort(by: { ($0.successRatePct ?? 0) < ($1.successRatePct ?? 1) })
            self?.collectionView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAlertAction.setValue(UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(launchDateAlertAction)
        alertController.addAction(launchCostAlertAction)
        alertController.addAction(successRateAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchData() {
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
        // Shadows
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.black.withAlphaComponent(0.37).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.configure(rocket: rockets[indexPath.row])
        cell.clipsToBounds = false
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
        return CGSize(width: view.frame.size.width - 2 * 18, height: 360)
    }
}
