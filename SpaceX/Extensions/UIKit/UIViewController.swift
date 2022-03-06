//
//  UIViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 06.03.2022.
//

import UIKit

extension UIViewController {
    
    func handleError(error: NetworkManagerError) {
        DispatchQueue.main.async {
            switch error {
            case .networkError:
                self.alertForError(title: "Unstable internet connection", message: "Please, check your connection and then try again or use a different network")
            case .parsingJSONError:
                self.alertForError(title: "Server error occured", message: "An incorrect response was received from the server. Please, restart the application or try again later")
            default:
                self.alertForError(title: "An unexpected error has occurred", message: "Please, restart application or wait for about 10-15 minutes")
            }
        }
    }
}
