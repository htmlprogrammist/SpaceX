//
//  MainTabBarController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabs()
    }
    
    func createTabs() {
        let rocketsViewController = createNavController(viewController: RocketsViewController(), itemName: "Rockets", itemImage: "rocket")
        let launchesViewController = createNavController(viewController: LaunchesViewController(), itemName: "Launches", itemImage: "adjustment")
        let launchpadsViewController = createNavController(viewController: LaunchpadsViewController(), itemName: "Launchpads", itemImage: "lego")
        
        viewControllers = [rocketsViewController, launchesViewController, launchpadsViewController]
    }
    
    func createNavController(viewController: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: itemName, image: UIImage(named: itemImage), tag: 0)
        return navController
    }
}
