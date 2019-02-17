//
//  LaunchViewController.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    private let ToMinifySegueIdentifier = "ToMinify"
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StoreManager.shared.configurePurchase {
            self.performSegue(withIdentifier: self.ToMinifySegueIdentifier, sender: nil)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
