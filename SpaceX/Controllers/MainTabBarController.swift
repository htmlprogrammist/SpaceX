//
//  MainTabBarController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    lazy var networkManager: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        let networkManager = NetworkManager(session: URLSession(configuration: configuration))
        return networkManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabs()
        
        tabBar.barTintColor = .glaucous
        tabBar.unselectedItemTintColor = .champagne
        tabBar.tintColor = .coral
    }
    
    private func createTabs() {
        let rocketsViewController = createNavController(viewController: RocketsViewController(networkManager: networkManager),
                                                        itemName: "Rockets", itemImage: "rocket")
        let launchesViewController = createNavController(viewController: LaunchesViewController(networkManager: networkManager),
                                                        itemName: "Launches", itemImage: "adjustment")
        let launchpadsViewController = createNavController(viewController: LaunchpadsViewController(networkManager: networkManager),
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
