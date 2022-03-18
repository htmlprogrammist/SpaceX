//
//  MainTabBarController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private lazy var networkManager: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        let networkManager = NetworkManager(session: URLSession(configuration: configuration))
        return networkManager
    }()
    private let transitionManager = TransitionManager(duration: 0.24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabs()
        
        delegate = self
        tabBar.barTintColor = .glaucous
        tabBar.unselectedItemTintColor = .champagne
        tabBar.tintColor = .coral
    }
    
    private func createTabs() {
        
        let rocketsViewController = createNavController(
            viewController: RocketsViewController(networkManager: networkManager, transitionManager: transitionManager),
            itemName: "Rockets", itemImage: "rocket")
        
        let launchesViewController = createNavController(
            viewController: LaunchesViewController(networkManager: networkManager, transitionManager: transitionManager),
            itemName: "Launches", itemImage: "adjustment")
        
        let launchpadsViewController = createNavController(
            viewController: LaunchpadsViewController(networkManager: networkManager, transitionManager: transitionManager),
            itemName: "Launchpads", itemImage: "lego")
        
        viewControllers = [rocketsViewController, launchesViewController, launchpadsViewController]
    }
    
    private func createNavController(viewController: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: itemName, image: UIImage(named: itemImage), tag: 0)
        navController.navigationBar.barTintColor = .glaucous
        navController.navigationBar.tintColor = .coral
        return navController
    }
}

// MARK: - Transitioning
extension MainTabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionManager(duration: 0.25, tabBarController: tabBarController, lastIndex: tabBarController.selectedIndex)
    }
}
