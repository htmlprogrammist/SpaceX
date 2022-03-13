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
    private let transitionManager = TransitionManager() // UIViewControllerAnimatedTransitioning, если мне сойдёт с рук использование одного транзишнМенеджера на весь проект
    
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
        cell.configure(rocket: rockets[indexPath.row])
        cell.clipsToBounds = false
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = RocketDetailViewController()
        destination.rocket = rockets[indexPath.row]
        destination.hidesBottomBarWhenPushed = true
        destination.transitioningDelegate = transitionManager
//        navigationController?.pushViewController(destination, animated: true)
        destination.modalPresentationStyle = .overCurrentContext
        present(destination, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 30, left: 18, bottom: 30, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2 * 18
        let height = width * 0.953
        return CGSize(width: width, height: height)
    }
}

extension RocketsViewController: TransitionManagerProtocol {
    
    func viewsToAnimate() -> [UIView] {
//        let cell: UICollectionViewCell
        if let indexPath = collectionView.indexPathsForSelectedItems {
            guard let cell = collectionView.cellForItem(at: indexPath.first ?? IndexPath()) as? RocketsCollectionViewCell else {
                RocketsCollectionViewCell()
//                UICollectionViewCell()
                return []
            }
            
            return [cell.imageView, cell.titleLabel]
        } else {
            return []
        }
        
//        guard let imageView = cell.imageView, let label = cell.titleLabel else {
//            return []
//        }
//        return [imageView, label]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
//        let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)!
        guard let cell = collectionView.cellForItem(at: collectionView.indexPathsForSelectedItems?.first ?? IndexPath()) as? RocketsCollectionViewCell else { return UIView() }
        if subView is UIImageView {
            return UIImageView(image: cell.imageView.image)
        } else {
            let label = UILabel()
            label.text = cell.titleLabel.text
            return label
        }
    }
}
