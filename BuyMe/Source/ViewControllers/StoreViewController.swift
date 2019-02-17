//
//  StoreViewController.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    @IBOutlet var realMoneyLabel: UILabel!
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var ethereumLabel: UILabel!
    @IBOutlet var bitcoinSellButton: UIButton!
    @IBOutlet var ethereumSellButton: UIButton!
    
    private static let realMoney = 1000.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
    }
    
    // MARK: - Configuration
    
    private func configureUserInterface() {
        realMoneyLabel.text = String(format: "%.1f", StatService.realMoney)
        bitcoinLabel.text = String(format: "%.5f", StatService.bitcoin)
        ethereumLabel.text = String(format: "%.5f", StatService.ethereum)
        bitcoinSellButton.isEnabled = StatService.bitcoin > 0
        ethereumSellButton.isEnabled = StatService.ethereum > 0
    }
    
    // MARK: - Actions
    
    @IBAction func realMoneyBuyButtonDidPress(_ sender: UIButton) {
        ActivityView.show {
            StoreManager.shared.buyRealMoney { error in
                ActivityView.hide { [unowned self] in
                    if error == nil {
                        StatService.addRealMoney(StoreViewController.realMoney)
                        self.configureUserInterface()
                    }
                }
            }
        }
    }
    
    @IBAction func bitcoinSellButtonDidPress(_ sender: UIButton) {
        StatService.sellBitcoin()
        configureUserInterface()
    }
    
    @IBAction func ethereumSellButtonDidPress(_ sender: UIButton) {
        StatService.sellEthereum()
        configureUserInterface()
    }
    
    @IBAction func forecastWeeklyButtonDidPress(_ sender: UIButton) {
        ActivityView.show {
            StoreManager.shared.subscribeOnWeeklyForecast { _ in
                ActivityView.hide {}
            }
        }
    }
    
    @IBAction func forecastMonthlyButtonDidPress(_ sender: UIButton) {
        ActivityView.show {
            StoreManager.shared.subscribeOnMonthlyForecast { _ in
                ActivityView.hide {}
            }
        }
    }
    
    @IBAction func forecastNewsWeeklyButtonDidPress(_ sender: UIButton) {
        ActivityView.show {
            StoreManager.shared.subscribeOnWeeklyForecastNews { _ in
                ActivityView.hide {}
            }
        }
    }
    
    @IBAction func forecastNewsMonthlyButtonDidPress(_ sender: UIButton) {
        ActivityView.show {
            StoreManager.shared.subscribeOnMonthlyForecastNews { _ in
                ActivityView.hide {}
            }
        }
    }
}
