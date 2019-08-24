//
//  ContainerViewController.swift
//  MusicTransition
//
//  Created by mac on 8/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
    @IBOutlet private weak var countingLabel: CountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countingLabel.count(fromValue: 0, to: 9999, withDuration: 10, andAnimationType: .EaseOut, andCounterType: .Int)
    }
}
