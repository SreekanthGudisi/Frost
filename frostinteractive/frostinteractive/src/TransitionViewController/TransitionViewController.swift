//
//  TransitionViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 04/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit

class TransitionViewController: NSObject , UIViewControllerAnimatedTransitioning {

    var popStyle: Bool = false

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.20
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if popStyle {

            animatePop(using: transitionContext)
            return
        }

        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.finalFrame(for: tz)

        let fOff = f.offsetBy(dx: f.width, dy: 55)
        tz.view.frame = fOff

        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }

    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {

        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 55)

        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
}
