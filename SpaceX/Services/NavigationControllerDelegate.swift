//
//  NavigationControllerDelegate.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 13.03.2022.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition: UIViewControllerAnimatedTransitioning?
        
        switch (fromVC, toVC) {
        case (_, is RocketDetailViewController):
            let transitionManager = TransitionManager()
            transitionManager.operation = .push
            transition = transitionManager
        case (is RocketDetailViewController, _):
            let transitionManager = TransitionManager()
            transitionManager.operation = .pop
            transition = transitionManager
        default:
            transition = nil
        }
        
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
