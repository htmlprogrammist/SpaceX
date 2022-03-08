//
//  RocketsViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class RocketsViewController: UIViewController {
    
    private var rockets = [Rocket]()
    private var networkManager: NetworkManagerProtocol
    private let collectionHeader = "collectionHeader"
    private let collectionFooter = "collectionFooter"
    
//    lazy var collectionView = UICollectionView(heightOfItem: 360)
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - (18 * 2), height: 360)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .transparent
        return collectionView
    }()
    
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
        
        getRockets()
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowUpAndDown"), style: .plain, target: self, action: #selector(sortButtonTapped))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RocketsCollectionViewCell.self, forCellWithReuseIdentifier: RocketsCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeader)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: collectionFooter)
        
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func sortButtonTapped() {
        print("Tapped")
    }
}

// MARK: - Networking
extension RocketsViewController {
    
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

// MARK: - CollectionView
extension RocketsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rockets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketsCollectionViewCell.identifier, for: indexPath) as? RocketsCollectionViewCell else { fatalError("Can not create CollectionViewCell at RocketsViewController") }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = RocketDetailViewController()
        destination.rocket = rockets[indexPath.row]
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeader, for: indexPath)
//        header.backgroundColor = .green
//        return header
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeader, for: indexPath)
            header.backgroundColor = UIColor.blue
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionFooter, for: indexPath)
            footer.backgroundColor = UIColor.green
            return footer
        default:
            fatalError("Unexpected element in \"viewForSupplementaryElementOfKind\" in RocketCollectionView")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
}
