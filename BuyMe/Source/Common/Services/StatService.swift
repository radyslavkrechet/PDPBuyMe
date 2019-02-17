//
//  StatService.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct StatService {
    static let minePrice = 0.1
    
    private static let realMoneyKey = "realMoney"
    private static let bitcoinKey = "bitcoin"
    private static let ethereumKey = "ethereum"
    
    static var realMoney: Double {
        return UserDefaults.standard.double(forKey: StatService.realMoneyKey)
    }
    static var bitcoin: Double {
        return UserDefaults.standard.double(forKey: StatService.bitcoinKey)
    }
    static var ethereum: Double {
        return UserDefaults.standard.double(forKey: StatService.ethereumKey)
    }
    
    // MARK: - Work With Money
    
    static func addRealMoney(_ value: Double) {
        let realMoney = StatService.realMoney + value
        UserDefaults.standard.set(realMoney, forKey: StatService.realMoneyKey)
    }
    
    static func sellBitcoin() {
        StatService.addRealMoney(StatService.bitcoin * ForecastManager.shared.todayBitcoin)
        UserDefaults.standard.set(0, forKey: StatService.bitcoinKey)
    }
    
    static func sellEthereum() {
        StatService.addRealMoney(StatService.ethereum * ForecastManager.shared.todayEtheteum)
        UserDefaults.standard.set(0, forKey: StatService.ethereumKey)
    }
    
    static func mine(withCards cards: [Card]) {
        var minedBitcoin = Double(0)
        var minedEthereum = Double(0)
        
        cards.forEach {
            let count = StatService.numberOfCards(withId: $0.id)
            
            if count > 0 {
                let result = $0.profit * Double(count)
                
                if $0.currency == .bitcoin {
                    minedBitcoin += result
                } else {
                    minedEthereum += result
                }
            }
        }
        
        let bitcoin = StatService.bitcoin + minedBitcoin
        UserDefaults.standard.set(bitcoin, forKey: StatService.bitcoinKey)
        
        let ethereum = StatService.ethereum + minedEthereum
        UserDefaults.standard.set(ethereum, forKey: StatService.ethereumKey)
        
        let realMoney = StatService.realMoney - StatService.minePrice
        UserDefaults.standard.set(realMoney, forKey: StatService.realMoneyKey)
    }
    
    // MARK: - Work With Cards
    
    static func numberOfCards(withId id: String) -> Int {
        return UserDefaults.standard.integer(forKey: id)
    }
    
    static func buyCard(_ card: Card) {
        var realMoney = StatService.realMoney
        
        if realMoney >= card.price {
            realMoney -= card.price
            UserDefaults.standard.set(realMoney, forKey: StatService.realMoneyKey)
            
            var numberOfCards = StatService.numberOfCards(withId: card.id)
            numberOfCards += 1
            UserDefaults.standard.set(numberOfCards, forKey: card.id)
        }
    }
}
