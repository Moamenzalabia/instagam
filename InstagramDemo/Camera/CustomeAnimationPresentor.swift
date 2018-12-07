//  CustomeAnimationPresentor.swift
//  InstagramDemo
//  Created by MOAMEN on 9/11/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import Foundation
import UIKit

class CustomeAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // my custom transition animation code logic
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return}
        guard let toView = transitionContext.view(forKey: .to) else { return}
        
        containerView.addSubview(toView)
        let startingFrome = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrome
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
           //animation???
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }

    }
    
}


