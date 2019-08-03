//
//  ModalViewController.swift
//  MusicTransition
//
//  Created by mac on 7/4/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import UIKit

final class ModalViewController: UIViewController {
    
    var tapCloseButtonActionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
    }

    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        tapCloseButtonActionHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ModalViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ModalViewController viewWillDisappear")
    }
}
