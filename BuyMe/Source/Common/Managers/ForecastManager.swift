//
//  ForecastManager.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

class ForecastManager {
    static let shared = ForecastManager()
    
    let todayBitcoin: Double
    let todayEtheteum: Double
    let tomorrowBitcoin: Double
    let tomorrowEthereum: Double
    
    private let bitcoinMin = UInt32(2000)
    private let bitcoinMax = UInt32(2500)
    private let ethereumMin = UInt32(200)
    private let ethereumMax = UInt32(250)
    
    // MARK: - Lifecycle
    
    private init() {
        todayBitcoin = Double(arc4random_uniform(bitcoinMax - bitcoinMin) + bitcoinMin)
        todayEtheteum = Double(arc4random_uniform(ethereumMax - ethereumMin) + ethereumMin)
        tomorrowBitcoin = Double(arc4random_uniform(bitcoinMax - bitcoinMin) + bitcoinMin)
        tomorrowEthereum = Double(arc4random_uniform(ethereumMax - ethereumMin) + ethereumMin)
    }
}
