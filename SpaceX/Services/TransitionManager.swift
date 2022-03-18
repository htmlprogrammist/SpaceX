//
//  TransitionManager.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 12.03.2022.
//

import UIKit

protocol TransitionManagerProtocol: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var duration: TimeInterval { get }
    var type: TransitionType { get }
    
    func animateTabBarController(transitionContext: UIViewControllerContextTransitioning)
    func animateViewControllers(transitionContext: UIViewControllerContextTransitioning)
}

protocol Transitionable {
    var view: UIView! { get set }
    
    // Return the views which shoud be animated in the transition
    func viewsToAnimate() -> [UIView]
    
    // Return a copy of the view which is passed in.
    // The passed in view is one of the views to animate
    func copyForView(_ subView: UIView) -> UIView
}

public enum TransitionType {
    case tabBarController
    case viewController
}

private enum PresentationType {
    case presentation
    case dismissal
}

final class TransitionManager: NSObject, TransitionManagerProtocol {
    
    public var duration: TimeInterval
    public var type: TransitionType
    
    // For view controllers
    private var presentationTypeVC: PresentationType?
    private var fromVC: UIViewController?
    private var toVC: UIViewController?
    
    // For tab bar controller
    private var tabBarController: UITabBarController?
    private var lastIndex: Int?
    
    init(duration: TimeInterval) {
        self.duration = duration
        type = .viewController
    }
    
    init(duration: TimeInterval, tabBarController: UITabBarController, lastIndex: Int) {
        self.duration = duration
        self.tabBarController = tabBarController
        self.lastIndex = lastIndex
        type = .tabBarController
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .tabBarController:
            animateTabBarController(transitionContext: transitionContext)
        case .viewController:
            animateViewControllers(transitionContext: transitionContext)
        }
    }
    
    // MARK: - Transitioning methods (TabBar & ViewController)
    func animateTabBarController(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let tabBarController = tabBarController,
              let lastIndex = lastIndex
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        var viewWidth = toViewController.view.bounds.width
        
        if tabBarController.selectedIndex < lastIndex {
            viewWidth = -viewWidth
        }
        
        toViewController.view.transform = CGAffineTransform(translationX: viewWidth, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: (transitionContext)), delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 2.5, options: .transitionCrossDissolve, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform(translationX: -viewWidth, y: 0)
        }, completion: { _ in
            fromViewController.view.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func animateViewControllers(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = fromVC as? Transitionable,
              let toViewController = toVC as? Transitionable
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        if presentationTypeVC == .dismissal {
            containerView.bringSubviewToFront(fromViewController.view)
        }
        
        let fromViews = fromViewController.viewsToAnimate()
        let toViews = toViewController.viewsToAnimate()
        
        assert(fromViews.count == toViews.count, "Number of elements in fromViews and toViews have to be the same.")
        
        var intermediateViews = [UIView]()
        var toFrames = [CGRect]()
        
        for i in 0..<fromViews.count {
            let fromView = fromViews[i]
            let fromFrame = fromView.superview!.convert(fromView.frame, to: nil)
            fromView.alpha = 0
            
            let intermediateView = fromViewController.copyForView(fromView)
            intermediateView.frame = fromFrame
            containerView.addSubview(intermediateView)
            intermediateViews.append(intermediateView)
            
            let toView = toViews[i]
            var toFrame: CGRect
            
            toFrame = toView.superview!.convert(toView.frame, to: nil)
            toFrames.append(toFrame)
            toView.alpha = 0
        }
        
        if presentationTypeVC == .presentation {
            toViewController.view.frame = fromViewController.view.frame.offsetBy(dx: 0, dy: fromViewController.view.frame.size.height)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: { () -> Void in
            if self.presentationTypeVC == .dismissal {
                fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: 0, dy: fromViewController.view.frame.size.height)
            } else {
                toViewController.view.frame = fromViewController.view.frame
            }
            
            for i in 0..<intermediateViews.count {
                let intermediateView = intermediateViews[i]
                intermediateView.frame = toFrames[i]
//                intermediateView.backgroundColor = .red // в ту сторону работает нормально, а вот в обратную - нифига
            }
        }) { (_) -> Void in
            for i in 0..<intermediateViews.count {
                intermediateViews[i].removeFromSuperview()
                
                fromViews[i].alpha = 1
                toViews[i].alpha = 1
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationTypeVC = .presentation
        fromVC = source
        toVC = presented
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationTypeVC = .dismissal
        // This code is safe, because TabBar is hidden, so there won't be any chances to switch to another VC and skip this `forDismissed` method
        toVC = fromVC // last `fromVC` is now `toVC`.
        fromVC = dismissed // and now we set our dismissed VC to fromVC
        return self
    }
}
