//
//  ForecastViewController.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet var todayBitcoinLabel: UILabel!
    @IBOutlet var todayEtheteumLabel: UILabel!
    @IBOutlet var tomorrowBitcoinLabel: UILabel!
    @IBOutlet var tomorrowEthereumLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
    }
    
    // MARK: - Configuration
    
    private func configureUserInterface() {
        todayBitcoinLabel.text = String(format: "%.1f", ForecastManager.shared.todayBitcoin) + "$"
        todayEtheteumLabel.text = String(format: "%.1f", ForecastManager.shared.todayEtheteum) + "$"
        tomorrowBitcoinLabel.text = String(format: "%.1f", ForecastManager.shared.tomorrowBitcoin) + "$"
        tomorrowEthereumLabel.text = String(format: "%.1f", ForecastManager.shared.tomorrowEthereum) + "$"
    }
}
