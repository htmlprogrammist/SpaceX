//
//  TransitionManager.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 12.03.2022.
//

import UIKit

protocol TransitionManagerProtocol {
    var duration: TimeInterval { get }
    
    // UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    
    // UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
}

protocol Transitionable {
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

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, TransitionManagerProtocol {
    
    public var duration: TimeInterval
    private var type: PresentationType?
    private var fromVC: UIViewController?
    private var toVC: UIViewController?
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
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
        
        if type == .dismissal {
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
        fromVC = source
        toVC = presented
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .dismissal
        toVC = fromVC // last `fromVC` is now `toVC`
        fromVC = dismissed // and now we set this to fromVC
        return self
    }
}
