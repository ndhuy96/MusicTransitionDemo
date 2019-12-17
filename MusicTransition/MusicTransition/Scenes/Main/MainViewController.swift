//
//  ViewController.swift
//  MusicTransition
//
//  Created by mac on 6/25/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

final class MainViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet private weak var miniPlayerButton: UIButton!
    
    private var animator: ARNTransitionAnimator?
    fileprivate var modalVC: ModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController viewWillDisappear")
    }
    
    private func config() {
        modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        modalVC.modalPresentationStyle = .overCurrentContext
        
        let color = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
        miniPlayerButton.setBackgroundImage(generateImageWithColor(color), for: .highlighted)
        
        setupAnimator()
    }
    
    private func setupAnimator() {
        let animation = MusicPlayerTransitionAnimation(rootVC: self, modalVC: modalVC)
        animation.completion = { [weak self] isPresenting in
            guard let self = self else { return }
            if isPresenting {
                let modalGestureHandler = TransitionGestureHandler(targetView: self.modalVC.view, direction: .bottom)
                modalGestureHandler.panCompletionThreshold = 15.0
                self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: modalGestureHandler)
            } else {
                self.setupAnimator()
            }
        }
        
        let gestureHandler = TransitionGestureHandler(targetView: miniPlayerView, direction: .top)
        gestureHandler.panCompletionThreshold = 15.0
        gestureHandler.panFrameSize = view.bounds.size
        
        animator = ARNTransitionAnimator(duration: 0.5, animation: animation)
        animator?.registerInteractiveTransitioning(.present, gestureHandler: gestureHandler)
        
        modalVC.transitioningDelegate = animator
    }
    
    @IBAction func handleMiniPlayerButtonTapped(_ sender: Any) {
         present(modalVC, animated: true)
    }
    
    fileprivate func generateImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

