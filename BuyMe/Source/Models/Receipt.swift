//
//  Receipt.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

enum AutoRenewStatus: Int {
    case turnedOff, willRenew
}

struct Receipt {
    var productId: String
    var autoRenewStatus: AutoRenewStatus
    
    private static let productIdKey = "product_id"
    private static let autoRenewStatusKey = "auto_renew_status"

    init(json: [String: Any]) {
        productId = json[Receipt.productIdKey] as! String
        autoRenewStatus = json[Receipt.autoRenewStatusKey] as! String == "0" ? .turnedOff : .willRenew
    }
}
