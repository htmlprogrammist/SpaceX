//
//  RocketsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class RocketsViewController: UICollectionViewController {
    
    private var rockets = [Rocket]()
    private let networkManager: NetworkManagerProtocol
    private let transitionManager: TransitionManagerProtocol
    
    public var selectedCell: RocketsCollectionViewCell? // a cell that was selected (tapped). Needed for transitions.
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowUpAndDown"), style: .plain, target: self, action: #selector(sortButtonTapped))
        view.backgroundColor = .glaucous
        collectionView.backgroundColor = .clear
        collectionView.register(RocketsCollectionViewCell.self, forCellWithReuseIdentifier: RocketsCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let selectedCell = selectedCell else { return } // if else - do nothing
        UIView.transition(with: selectedCell, duration: transitionManager.duration, options: .curveEaseInOut, animations: {
            selectedCell.mainStackView.alpha = 1
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let selectedCell = selectedCell else { return } // if else - do nothing
        UIView.transition(with: selectedCell, duration: transitionManager.duration, options: .curveEaseInOut, animations: {
            selectedCell.mainStackView.alpha = 0
        }, completion: nil)
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
        selectedCell = collectionView.cellForItem(at: indexPath) as? RocketsCollectionViewCell
        
        let destination = RocketDetailViewController(rocket: rockets[indexPath.row])
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

// MARK: - Transitioning
extension RocketsViewController: Transitionable {
    
    func viewsToAnimate() -> [UIView] {
        guard let selectedCell = selectedCell else { return [] }
        
        return [selectedCell.imageView, selectedCell.titleLabel]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        guard let selectedCell = selectedCell else { return UIView() }
        
        switch subView {
        case is UIImageView:
            let imageViewCopy = UIImageView(image: selectedCell.imageView.image)
            imageViewCopy.contentMode = selectedCell.imageView.contentMode
            imageViewCopy.clipsToBounds = true
            return imageViewCopy
        case is UILabel:
            let labelCopy = UILabel()
            labelCopy.text = selectedCell.titleLabel.text
            labelCopy.font = selectedCell.titleLabel.font
            labelCopy.textColor = .white
            return labelCopy
        default:
            return subView
        }
    }
}
