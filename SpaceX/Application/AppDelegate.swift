//
//  AppDelegate.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 06.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var networkManager: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        let networkManager = NetworkManager(session: URLSession(configuration: configuration))
        return networkManager
    }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RocketsViewController(networkManager: networkManager)
        window?.makeKeyAndVisible()
        
        return true
    }
}
