//
//  MusicPlayerTransitionAnimation.swift
//  MusicTransition
//
//  Created by mac on 7/4/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import Foundation
import UIKit
import ARNTransitionAnimator

final class MusicPlayerTransitionAnimation: TransitionAnimatable {
    
    fileprivate weak var rootVC: MainViewController!
    fileprivate weak var modalVC: ModalViewController!
    
    var completion: ((Bool) -> Void)?
    
    private var miniPlayerStartFrame: CGRect = CGRect.zero
    private var tabBarStartFrame: CGRect = CGRect.zero
    
    private var containerView: UIView?
    
    deinit {
        print("deinit MusicPlayerTransitionAnimation")
    }
    
    init(rootVC: MainViewController, modalVC: ModalViewController) {
        self.rootVC = rootVC
        self.modalVC = modalVC
    }
    
    func prepareContainer(_ transitionType: TransitionType, containerView: UIView, from fromVC: UIViewController, to toVC: UIViewController) {
        self.containerView = containerView
        if transitionType.isPresenting {
            rootVC.view.insertSubview(modalVC.view, belowSubview: rootVC.miniPlayerView)
        } else {
            rootVC.view.insertSubview(modalVC.view, belowSubview: rootVC.miniPlayerView)
        }
        rootVC.view.setNeedsLayout()
        rootVC.view.layoutIfNeeded()
        modalVC.view.setNeedsLayout()
        modalVC.view.layoutIfNeeded()
        
        miniPlayerStartFrame = rootVC.miniPlayerView.frame
        tabBarStartFrame = rootVC.tabBarController!.tabBar.frame
    }
    
    func willAnimation(_ transitionType: TransitionType, containerView: UIView) {
        if transitionType.isPresenting {
            rootVC.beginAppearanceTransition(true, animated: false)
            modalVC.view.frame.origin.y = rootVC.miniPlayerView.frame.origin.y + rootVC.miniPlayerView.frame.size.height
        } else {
            rootVC.beginAppearanceTransition(false, animated: false)
            rootVC.miniPlayerView.alpha = 1.0
            rootVC.miniPlayerView.frame.origin.y = -rootVC.miniPlayerView.bounds.size.height
            rootVC.tabBarController!.tabBar.frame.origin.y = containerView.bounds.size.height
        }
    }
    
    func updateAnimation(_ transitionType: TransitionType, percentComplete: CGFloat) {
        if transitionType.isPresenting {
            // miniPlayerView
            let startOriginY = miniPlayerStartFrame.origin.y
            let endOriginY = -miniPlayerStartFrame.size.height
            let diff = -endOriginY + startOriginY
            // tabBar
            let tabStartOriginY = tabBarStartFrame.origin.y
            let tabEndOriginY = modalVC.view.frame.size.height
            let tabDiff = tabEndOriginY - tabStartOriginY
            
            let playerY = startOriginY - (diff * percentComplete)
            rootVC.miniPlayerView.frame.origin.y = max(min(playerY,  miniPlayerStartFrame.origin.y), endOriginY)
            
            modalVC.view.frame.origin.y = rootVC.miniPlayerView.frame.origin.y + rootVC.miniPlayerView.frame.size.height
            let tabY = tabStartOriginY + (tabDiff * percentComplete)
            rootVC.tabBarController!.tabBar.frame.origin.y = min(max(tabY, tabBarStartFrame.origin.y), tabEndOriginY)
            
            let alpha = 1.0 - (1.0 * percentComplete)
            rootVC.containerView.subviews.forEach { $0.alpha = alpha + 0.4 }
            rootVC.tabBarController!.tabBar.alpha = alpha
        } else {
            // miniPlayerView
            let startOriginY = 0 - rootVC.miniPlayerView.bounds.size.height
            let endOriginY = miniPlayerStartFrame.origin.y
            let diff = -startOriginY + endOriginY
            // tabBar
            let tabStartOriginY = rootVC.containerView.bounds.size.height
            let tabEndOriginY = tabBarStartFrame.origin.y
            let tabDiff = tabStartOriginY - tabEndOriginY
            
            rootVC.miniPlayerView.frame.origin.y = startOriginY + (diff * percentComplete)
            modalVC.view.frame.origin.y = rootVC.miniPlayerView.frame.origin.y + rootVC.miniPlayerView.frame.size.height
            
            rootVC.tabBarController!.tabBar.frame.origin.y = tabStartOriginY - (tabDiff * (1.0 - percentComplete))
            
            let alpha = 1.0 * percentComplete
            rootVC.containerView.subviews.forEach { $0.alpha = alpha + 0.4 }
            rootVC.tabBarController!.tabBar.alpha = alpha
        }
    }
    
    func finishAnimation(_ transitionType: TransitionType, didComplete: Bool) {
        rootVC.endAppearanceTransition()
        
        if transitionType.isPresenting {
            if didComplete {
                rootVC.miniPlayerView.alpha = 0.0
                modalVC.view.removeFromSuperview()
                containerView?.addSubview(modalVC.view)
                completion?(transitionType.isPresenting)
            } else {
                rootVC.beginAppearanceTransition(true, animated: false)
                rootVC.endAppearanceTransition()
            }
        } else {
            if didComplete {
                modalVC.view.removeFromSuperview()
                completion?(transitionType.isPresenting)
            } else {
                rootVC.miniPlayerView.alpha = 0.0
                modalVC.view.removeFromSuperview()
                containerView?.addSubview(modalVC.view)
                rootVC.beginAppearanceTransition(false, animated: false)
                rootVC.endAppearanceTransition()
            }
        }
    }
}

extension MusicPlayerTransitionAnimation {
    func sourceVC() -> UIViewController { return rootVC }
    func destVC() -> UIViewController { return modalVC }
}


