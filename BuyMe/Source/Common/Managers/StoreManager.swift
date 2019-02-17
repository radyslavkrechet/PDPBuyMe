//
//  StoreManager.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import StoreKit

typealias Completion = () -> Void

class StoreManager {
    static let shared = StoreManager()
    
    var isNewsEnabled: Bool {
        guard receipts != nil else {
            return false
        }
        
        let isEmpty = receipts.filter { $0.autoRenewStatus == .willRenew && $0.productId.contains("news") }.isEmpty
        return !isEmpty
    }
    var isForecastEnabled: Bool {
        guard receipts != nil else {
            return false
        }
        
        let isEmpty = receipts.filter { $0.autoRenewStatus == .willRenew }.isEmpty
        return !isEmpty
    }
    
    private let realMoneyIdentifier = ".realmoney"
    private let forecastWeeklyIdentifier = ".subscription.forecast.weekly"
    private let forecastMonthlyIdentifier = ".forecast.monthly"
    private let forecastNewsWeeklyIdentifier = ".forecastnews.weekly"
    private let forecastNewsMonthlyIdentifier = ".forecastnews.monthly"
    
    private let sharedSecret = "0eaa2a59a08948378c9dd52403c97fe6"
    private let verifyReceiptUrl = "https://sandbox.itunes.apple.com/verifyReceipt"
    private let httpMethodPost = "POST"
    private let receiptDataKey = "receipt-data"
    private let passwordKey = "password"
    private let pendingRenewalInfo = "pending_renewal_info"
    
    private var products: [SKProduct]!
    private var receipts: [Receipt]!
    
    private var receiptData: Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        let data = try? Data(contentsOf: url)
        return data
    }
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Work With Purchase
    
    func configurePurchase(completion: @escaping Completion) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let realMoney = bundleIdentifier + realMoneyIdentifier
        let forecastWeekly = bundleIdentifier + forecastWeeklyIdentifier
        let forecastMonthly = bundleIdentifier + forecastMonthlyIdentifier
        let forecastNewsWeekly = bundleIdentifier + forecastNewsWeeklyIdentifier
        let forecastNewsMonthly = bundleIdentifier + forecastNewsMonthlyIdentifier
        
        PurchaseManager.shared.productIdentifiers = [realMoney,
                                                     forecastWeekly,
                                                     forecastMonthly,
                                                     forecastNewsWeekly,
                                                     forecastNewsMonthly]
        
        PurchaseManager.shared.requestProducts { [unowned self] products, _ in
            self.products = products
            
            self.verifyReceipt { completion() }
        }
    }
    
    func buyRealMoney(completion: @escaping TransactionCompletion) {
        buyProduct(withIdentifier: realMoneyIdentifier, completion: completion)
    }
    
    func subscribeOnWeeklyForecast(completion: @escaping TransactionCompletion) {
        subscribeOnProduct(withIdentifier: forecastWeeklyIdentifier, completion: completion)
    }
    
    func subscribeOnMonthlyForecast(completion: @escaping TransactionCompletion) {
        subscribeOnProduct(withIdentifier: forecastMonthlyIdentifier, completion: completion)
    }
    
    func subscribeOnWeeklyForecastNews(completion: @escaping TransactionCompletion) {
        subscribeOnProduct(withIdentifier: forecastNewsWeeklyIdentifier, completion: completion)
    }
    
    func subscribeOnMonthlyForecastNews(completion: @escaping TransactionCompletion) {
        subscribeOnProduct(withIdentifier: forecastNewsMonthlyIdentifier, completion: completion)
    }
    
    private func buyProduct(withIdentifier indetifier: String, completion: @escaping TransactionCompletion) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let product = products.filter { $0.productIdentifier == bundleIdentifier + indetifier }.first!
        
        PurchaseManager.shared.buy(product: product, completion: completion)
    }
    
    private func subscribeOnProduct(withIdentifier indetifier: String, completion: @escaping TransactionCompletion) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let product = products.filter { $0.productIdentifier == bundleIdentifier + indetifier }.first!
        
        PurchaseManager.shared.buy(product: product) { [unowned self] error in
            self.verifyReceipt { completion(error) }
        }
    }
    
    private func restoreProducts(completion: @escaping RestoreCompletion) {
        PurchaseManager.shared.restore { [unowned self] isRestored, error in
            self.verifyReceipt { completion(isRestored, error) }
        }
    }
    
    private func verifyReceipt(completion: @escaping Completion) {
        if let data = receiptData {
            let json = [receiptDataKey: data.base64EncodedString(), passwordKey: sharedSecret]
            let body = try! JSONSerialization.data(withJSONObject: json)
            let url = URL(string: verifyReceiptUrl)!
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethodPost
            request.httpBody = body
            
            let task = URLSession.shared.dataTask(with: request) { (responseData, _, _) in
                DispatchQueue.main.async { [unowned self] in
                    if let responseData = responseData {
                        let json = try! JSONSerialization.jsonObject(with: responseData) as! [String: Any]
                        if let objects = json[self.pendingRenewalInfo] as? [[String: Any]] {
                            var receipts = [Receipt]()
                            
                            for object in objects {
                                let receipt = Receipt(json: object)
                                receipts.append(receipt)
                            }
                            
                            self.receipts = receipts
                            
                            completion()
                        } else {
                            completion()
                        }
                    } else {
                        completion()
                    }
                }
            }
            
            task.resume()
        } else {
            completion()
        }
    }
}
