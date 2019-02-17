//
//  CardService.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct CardService {
    private static let resource = "Cards"
    private static let type = "plist"
    
    static var cards: [Card] {
        return contents.map { Card(json: $0) }.sorted(by: { $0.price < $1.price })
    }
    
    private static var contents: [[String: Any]] {
        let path = Bundle.main.path(forResource: resource, ofType: type)!
        return NSArray(contentsOfFile: path) as! [[String: Any]]
    }
}
