//
//  TransitionManager.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 12.03.2022.
//

import UIKit

protocol TransitionManagerProtocol {
    var view: UIView! { get set }
    
    // Return the views which shoud be animated in the transition
    func viewsToAnimate() -> [UIView]
    
    // Return a copy of the view which is passed in
    // The passed in view is one of the views to animate
    func copyForView(_ subView: UIView) -> UIView
}

enum PresentationType {
    
    case presentation
    case dismissal
    
    var isPresenting: Bool {
        return self == .presentation
    }
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    static let duration = 0.4
    
    private var type: PresentationType?
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        TransitionManager.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? TransitionManagerProtocol,
              let toViewController = transitionContext.viewController(forKey: .to) as? TransitionManagerProtocol
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        if type == .dismissal {
            containerView.bringSubviewToFront(fromViewController.view)
        }
        
//        fromViewController.view.setNeedsLayout()
//        fromViewController.view.layoutIfNeeded()
        
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
//            if let tempToFrame = toViewController.frameForView?(toView) {
//                toFrame = tempToFrame
//            } else {
//                toFrame = toView.superview!.convert(toView.frame, to: nil)
//            }
            toFrame = toView.superview!.convert(toView.frame, to: nil) // code from if-else above
            toFrames.append(toFrame)
            toView.alpha = 0
        }
        
        if type == .presentation {
            toViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.size.width, dy: 0)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: { () -> Void in
            if self.type == .dismissal {
                fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.size.width, dy: 0)
            } else {
                toViewController.view.frame = fromViewController.view.frame
            }
            
            for i in 0..<intermediateViews.count {
                let intermediateView = intermediateViews[i]
                intermediateView.frame = toFrames[i]
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
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .dismissal
        return self
    }
}