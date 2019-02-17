//
//  Card.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

enum Currency {
    case bitcoin, ethereum
}

struct Card {
    private static let idKey = "id"
    private static let nameKey = "name"
    private static let priceKey = "price"
    private static let currencyKey = "currency"
    private static let profitKey = "profit"
    
    var id: String
    var name: String
    var price: Double
    var currency: Currency
    var profit: Double
    
    init(json: [String: Any]) {
        id = json[Card.idKey] as! String
        name = json[Card.nameKey] as! String
        price = (json[Card.priceKey] as! NSNumber).doubleValue
        currency = (json[Card.currencyKey] as! NSNumber).intValue == 0 ? .bitcoin : .ethereum
        profit = (json[Card.profitKey] as! NSNumber).doubleValue
    }
}
